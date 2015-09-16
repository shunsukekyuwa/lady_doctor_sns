// Copyright 2011 the V8 project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include "v8.h"

#include "bootstrapper.h"
#include "debug.h"
#include "scopeinfo.h"

namespace v8 {
namespace internal {

JSBuiltinsObject* Context::builtins() {
  GlobalObject* object = global();
  if (object->IsJSGlobalObject()) {
    return JSGlobalObject::cast(object)->builtins();
  } else {
    ASSERT(object->IsJSBuiltinsObject());
    return JSBuiltinsObject::cast(object);
  }
}


Context* Context::global_context() {
  // Fast case: the global object for this context has been set.  In
  // that case, the global object has a direct pointer to the global
  // context.
  if (global()->IsGlobalObject()) {
    return global()->global_context();
  }

  // During bootstrapping, the global object might not be set and we
  // have to search the context chain to find the global context.
  ASSERT(Isolate::Current()->bootstrapper()->IsActive());
  Context* current = this;
  while (!current->IsGlobalContext()) {
    JSFunction* closure = JSFunction::cast(current->closure());
    current = Context::cast(closure->context());
  }
  return current;
}


JSObject* Context::global_proxy() {
  return global_context()->global_proxy_object();
}

void Context::set_global_proxy(JSObject* object) {
  global_context()->set_global_proxy_object(object);
}


Handle<Object> Context::Lookup(Handle<String> name, ContextLookupFlags flags,
                               int* index_, PropertyAttributes* attributes) {
  Isolate* isolate = GetIsolate();
  Handle<Context> context(this, isolate);

  bool follow_context_chain = (flags & FOLLOW_CONTEXT_CHAIN) != 0;
  *index_ = -1;
  *attributes = ABSENT;

  if (FLAG_trace_contexts) {
    PrintF("Context::Lookup(");
    name->ShortPrint();
    PrintF(")\n");
  }

  do {
    if (FLAG_trace_contexts) {
      PrintF(" - looking in context %p", reinterpret_cast<void*>(*context));
      if (context->IsGlobalContext()) PrintF(" (global context)");
      PrintF("\n");
    }

    // check extension/with object
    if (context->has_extension()) {
      Handle<JSObject> extension = Handle<JSObject>(context->extension(),
                                                    isolate);
      // Context extension objects needs to behave as if they have no
      // prototype.  So even if we want to follow prototype chains, we
      // need to only do a local lookup for context extension objects.
      if ((flags & FOLLOW_PROTOTYPE_CHAIN) == 0 ||
          extension->IsJSContextExtensionObject()) {
        *attributes = extension->GetLocalPropertyAttribute(*name);
      } else {
        *attributes = extension->GetPropertyAttribute(*name);
      }
      if (*attributes != ABSENT) {
        // property found
        if (FLAG_trace_contexts) {
          PrintF("=> found property in context object %p\n",
                 reinterpret_cast<void*>(*extension));
        }
        return extension;
      }
    }

    if (context->is_function_context()) {
      // we have context-local slots

      // check non-parameter locals in context
      Handle<SerializedScopeInfo> scope_info(
          context->closure()->shared()->scope_info(), isolate);
      Variable::Mode mode;
      int index = scope_info->ContextSlotIndex(*name, &mode);
      ASSERT(index < 0 || index >= MIN_CONTEXT_SLOTS);
      if (index >= 0) {
        // slot found
        if (FLAG_trace_contexts) {
          PrintF("=> found local in context slot %d (mode = %d)\n",
                 index, mode);
        }
        *index_ = index;
        // Note: Fixed context slots are statically allocated by the compiler.
        // Statically allocated variables always have a statically known mode,
        // which is the mode with which they were declared when added to the
        // scope. Thus, the DYNAMIC mode (which corresponds to dynamically
        // declared variables that were introduced through declaration nodes)
        // must not appear here.
        switch (mode) {
          case Variable::INTERNAL:  // fall through
          case Variable::VAR: *attributes = NONE; break;
          case Variable::CONST: *attributes = READ_ONLY; break;
          case Variable::DYNAMIC: UNREACHABLE(); break;
          case Variable::DYNAMIC_GLOBAL: UNREACHABLE(); break;
          case Variable::DYNAMIC_LOCAL: UNREACHABLE(); break;
          case Variable::TEMPORARY: UNREACHABLE(); break;
        }
        return context;
      }

      // check parameter locals in context
      int param_index = scope_info->ParameterIndex(*name);
      if (param_index >= 0) {
        // slot found.
        int index = scope_info->ContextSlotIndex(
            isolate->heap()->arguments_shadow_symbol(), NULL);
        ASSERT(index >= 0);  // arguments must exist and be in the heap context
        Handle<JSObject> arguments(JSObject::cast(context->get(index)),
                                   isolate);
        if (FLAG_trace_contexts) {
          PrintF("=> found parameter %d in arguments object\n", param_index);
        }
        *index_ = param_index;
        *attributes = NONE;
        return arguments;
      }

      // check intermediate context (holding only the function name variable)
      if (follow_context_chain) {
        int index = scope_info->FunctionContextSlotIndex(*name);
        if (index >= 0) {
          // slot found
          if (FLAG_trace_contexts) {
            PrintF("=> found intermediate function in context slot %d\n",
                   index);
          }
          *index_ = index;
          *attributes = READ_ONLY;
          return context;
        }
      }
    }

    // proceed with enclosing context
    if (context->IsGlobalContext()) {
      follow_context_chain = false;
    } else if (context->is_function_context()) {
      context = Handle<Context>(Context::cast(context->closure()->context()),
                                isolate);
    } else {
      context = Handle<Context>(context->previous(), isolate);
    }
  } while (follow_context_chain);

  // slot not found
  if (FLAG_trace_contexts) {
    PrintF("=> no property/slot found\n");
  }
  return Handle<Object>::null();
}


bool Context::GlobalIfNotShadowedByEval(Handle<String> name) {
  Context* context = this;

  // Check that there is no local with the given name in contexts
  // before the global context and check that there are no context
  // extension objects (conservative check for with statements).
  while (!context->IsGlobalContext()) {
    // Check if the context is a potentially a with context.
    if (context->has_extension()) return false;

    // Not a with context so it must be a function context.
    ASSERT(context->is_function_context());

    // Check non-parameter locals.
    Handle<SerializedScopeInfo> scope_info(
        context->closure()->shared()->scope_info());
    Variable::Mode mode;
    int index = scope_info->ContextSlotIndex(*name, &mode);
    ASSERT(index < 0 || index >= MIN_CONTEXT_SLOTS);
    if (index >= 0) return false;

    // Check parameter locals.
    int param_index = scope_info->ParameterIndex(*name);
    if (param_index >= 0) return false;

    // Check context only holding the function name variable.
    index = scope_info->FunctionContextSlotIndex(*name);
    if (index >= 0) return false;
    context = Context::cast(context->closure()->context());
  }

  // No local or potential with statement found so the variable is
  // global unless it is shadowed by an eval-introduced variable.
  return true;
}


void Context::ComputeEvalScopeInfo(bool* outer_scope_calls_eval,
                                   bool* outer_scope_calls_non_strict_eval) {
  Context* context = this;
  while (true) {
    Handle<SerializedScopeInfo> scope_info(
        context->closure()->shared()->scope_info());
    if (scope_info->CallsEval()) {
      *outer_scope_calls_eval = true;
      if (!scope_info->IsStrictMode()) {
        // No need to go further since the answers will not change
        // from here.
        *outer_scope_calls_non_strict_eval = true;
        return;
      }
    }
    if (context->IsGlobalContext()) break;
    context = Context::cast(context->closure()->context());
  }
}


void Context::AddOptimizedFunction(JSFunction* function) {
  ASSERT(IsGlobalContext());
#ifdef DEBUG
  Object* element = get(OPTIMIZED_FUNCTIONS_LIST);
  while (!element->IsUndefined()) {
    CHECK(element != function);
    element = JSFunction::cast(element)->next_function_link();
  }

  CHECK(function->next_function_link()->IsUndefined());

  // Check that the context belongs to the weak global contexts list.
  bool found = false;
  Object* context = GetHeap()->global_contexts_list();
  while (!context->IsUndefined()) {
    if (context == this) {
      found = true;
      break;
    }
    context = Context::cast(context)->get(Context::NEXT_CONTEXT_LINK);
  }
  CHECK(found);
#endif
  function->set_next_function_link(get(OPTIMIZED_FUNCTIONS_LIST));
  set(OPTIMIZED_FUNCTIONS_LIST, function);
}


void Context::RemoveOptimizedFunction(JSFunction* function) {
  ASSERT(IsGlobalContext());
  Object* element = get(OPTIMIZED_FUNCTIONS_LIST);
  JSFunction* prev = NULL;
  while (!element->IsUndefined()) {
    JSFunction* element_function = JSFunction::cast(element);
    ASSERT(element_function->next_function_link()->IsUndefined() ||
           element_function->next_function_link()->IsJSFunction());
    if (element_function == function) {
      if (prev == NULL) {
        set(OPTIMIZED_FUNCTIONS_LIST, element_function->next_function_link());
      } else {
        prev->set_next_function_link(element_function->next_function_link());
      }
      element_function->set_next_function_link(GetHeap()->undefined_value());
      return;
    }
    prev = element_function;
    element = element_function->next_function_link();
  }
  UNREACHABLE();
}


Object* Context::OptimizedFunctionsListHead() {
  ASSERT(IsGlobalContext());
  return get(OPTIMIZED_FUNCTIONS_LIST);
}


void Context::ClearOptimizedFunctions() {
  set(OPTIMIZED_FUNCTIONS_LIST, GetHeap()->undefined_value());
}


#ifdef DEBUG
bool Context::IsBootstrappingOrContext(Object* object) {
  // During bootstrapping we allow all objects to pass as
  // contexts. This is necessary to fix circular dependencies.
  return Isolate::Current()->bootstrapper()->IsActive() || object->IsContext();
}


bool Context::IsBootstrappingOrGlobalObject(Object* object) {
  // During bootstrapping we allow all objects to pass as global
  // objects. This is necessary to fix circular dependencies.
  Isolate* isolate = Isolate::Current();
  return isolate->heap()->gc_state() != Heap::NOT_IN_GC ||
      isolate->bootstrapper()->IsActive() ||
      object->IsGlobalObject();
}
#endif

} }  // namespace v8::internal
