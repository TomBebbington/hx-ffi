#define IMPLEMENT_API
#define NEKO_COMPATIBLE
#include <hx/CFFI.h>
#include <ffi.h>
#include <stdio.h>
#include <string.h>
#include <sstream>
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#define WINDOWS
#include <windows.h>
#else
#define UNIX
#include <dlfcn.h>
#endif
DEFINE_KIND(k_ffi_type);
DEFINE_KIND(k_ffi_cif);
DEFINE_KIND(k_function);
DEFINE_KIND(k_library);
DEFINE_KIND(k_pointer);
#define wrap_pointer(ptr)			(ptr == 0 ? alloc_null() : alloc_abstract(k_pointer, (void*) ptr))
#define unwrap_pointer(ptr)			(val_is_string(ptr) ? (uintptr_t) val_string(ptr) : (val_is_null(ptr) ? NULL : ((uintptr_t) val_data(ptr))))
#define TYPE(n) \
value hx_ffi_type_##n() { \
	return alloc_abstract(k_ffi_type, &ffi_type_##n); \
} \
DEFINE_PRIM(hx_ffi_type_##n, 0);
TYPE(void)
TYPE(uint8);
TYPE(sint8);
TYPE(uint16);
TYPE(sint16);
TYPE(uint32);
TYPE(sint32);
TYPE(uint64);
TYPE(sint64);
TYPE(float);
TYPE(double);
TYPE(uchar);
TYPE(schar);
TYPE(ushort);
TYPE(sshort);
TYPE(sint);
TYPE(uint);
TYPE(longdouble);
TYPE(pointer);
value hx_ffi_get_type_size(value type) {
	return alloc_int(((ffi_type*) val_data(type)) -> size);
}
DEFINE_PRIM(hx_ffi_get_type_size, 1);

value hx_ffi_get_type_type(value type) {
	return alloc_int(((ffi_type*) val_data(type)) -> type);
}
DEFINE_PRIM(hx_ffi_get_type_type, 1);

value hx_ffi_get_type_alignment(value type) {
	return alloc_int(((ffi_type*) val_data(type)) -> alignment);
}
DEFINE_PRIM(hx_ffi_get_type_alignment, 1);

value hx_ffi_make_struct_type(value els) {
	const uint len = val_array_size(els);
	ffi_type** elements = new ffi_type*[len+1];
	for(uint i=0;i<len;i++) {
		elements[i] = (ffi_type*) val_data(val_array_i(els, i));
	}
	elements[len] = NULL;
	ffi_type *t = new ffi_type();
	t -> type = FFI_TYPE_STRUCT;
	t -> elements = elements;
	return alloc_abstract(k_ffi_type, t);
}
DEFINE_PRIM(hx_ffi_make_struct_type, 1);

value hx_ffi_type_get_elements(value t) {
	ffi_type* ty = (ffi_type*) val_data(t);
	if(ty -> type == FFI_TYPE_STRUCT) {
		ffi_type** elements = ty -> elements;
		uint len = 0;
		while(true) {
			if(elements[len] == NULL)
				break;
			len++;
		}
		value arr = alloc_array(len);
		for(uint i=0; i<len;i++)
			val_array_set_i(arr, i, alloc_abstract(k_ffi_type, elements[i]));
		return arr;
	} else {
		return alloc_null();
	}
}
DEFINE_PRIM(hx_ffi_type_get_elements, 1);
value hx_ffi_cif_create() {
	ffi_cif* cif = new ffi_cif();
	return alloc_abstract(k_ffi_cif, cif);
}
DEFINE_PRIM(hx_ffi_cif_create, 0);

value hx_ffi_cif_get_return_type(value v_cif) {
	ffi_cif* cif = (ffi_cif*) val_data(v_cif);
	return alloc_abstract(k_ffi_type, cif -> rtype);
}
DEFINE_PRIM(hx_ffi_cif_get_return_type, 1);

value hx_ffi_cif_get_arg_types(value v_cif) {
	const ffi_cif* cif = (ffi_cif*) val_data(v_cif);
	const uint num = cif -> nargs;
	value v = alloc_array(num);
	for(uint i=0;i<num;i++) {
		val_array_set_i(v, i, alloc_abstract(k_ffi_type, cif -> arg_types[i]));
	}
	return v;
}
DEFINE_PRIM(hx_ffi_cif_get_arg_types, 1);

value hx_ffi_cif_prep(value v_cif, value v_args, value v_ret) {
	const ffi_cif* cif = (ffi_cif*) val_data(v_cif);
	const uint args_size = val_array_size(v_args);
	ffi_type** args = new ffi_type*[args_size];
	for(uint i=0;i<args_size;i++) {
		args[i] = (ffi_type*) val_data(val_array_i(v_args, i));
	}
	const ffi_type* ret = (ffi_type*) val_data(v_ret);
	return alloc_int(ffi_prep_cif((ffi_cif*) cif, FFI_DEFAULT_ABI, args_size, (ffi_type*) ret, args));
}
DEFINE_PRIM(hx_ffi_cif_prep, 3);

#define PTR_TYPE(ffi, c, neko)		case ffi: return new c(neko(val));
value from_pointer(void* ptr, ffi_type* t);
void* to_pointer(value val, ffi_type* t) {
	const uint type = t -> type;
	switch(type) {
		PTR_TYPE(FFI_TYPE_INT, int, val_int)
		PTR_TYPE(FFI_TYPE_FLOAT, float, val_number)
		PTR_TYPE(FFI_TYPE_DOUBLE, double, val_number)
		PTR_TYPE(FFI_TYPE_LONGDOUBLE, double, val_number)
		PTR_TYPE(FFI_TYPE_UINT8, uint8_t, val_int)
		PTR_TYPE(FFI_TYPE_SINT8, int8_t, val_int)
		PTR_TYPE(FFI_TYPE_UINT16, uint16_t, val_int)
		PTR_TYPE(FFI_TYPE_SINT16, int16_t, val_int)
		PTR_TYPE(FFI_TYPE_UINT32, uint32_t, val_int)
		PTR_TYPE(FFI_TYPE_SINT32, int32_t, val_int)
		PTR_TYPE(FFI_TYPE_POINTER, uintptr_t, unwrap_pointer)
		case FFI_TYPE_UINT64:
		case FFI_TYPE_SINT64: {
			const int64_t low = val_int(val_field(val, val_id("low")));
			const int64_t high = val_int(val_field(val, val_id("high")));
			return new int64_t(low | (high << 32));
		}
		case FFI_TYPE_STRUCT: {
			const uint size = t -> size;
			uintptr_t v = (uintptr_t) malloc(size);
			ffi_type** elem = t -> elements;
			uint i = 0;
			while(*elem != NULL) {
				const ffi_type* curr = *elem;
				const size_t size = curr -> size;
				uintptr_t nptr = (uintptr_t) to_pointer(val_array_i(val, i), *elem);
				memcpy((void*) v, (void*) nptr, size);
				v += size;
				elem++;
				i++;
			}
			return (void*) v;
		}
		default:
			val_throw(alloc_string("Unsupported type"));
			return NULL;
	}
}
#define FROM_TYPE(ffi, c, neko)		case ffi: return neko(*((c*) ptr));
value from_pointer(void* ptr, ffi_type* t) {
	switch(t -> type) {
		case FFI_TYPE_VOID:
			return alloc_null();
		FROM_TYPE(FFI_TYPE_INT, int, alloc_int)
		FROM_TYPE(FFI_TYPE_FLOAT, float, alloc_float)
		FROM_TYPE(FFI_TYPE_DOUBLE, double, alloc_float)
		FROM_TYPE(FFI_TYPE_LONGDOUBLE, double, alloc_float)
		FROM_TYPE(FFI_TYPE_UINT8, uint8_t, alloc_int)
		FROM_TYPE(FFI_TYPE_SINT8, int8_t, alloc_int)
		FROM_TYPE(FFI_TYPE_UINT16, uint16_t, alloc_int)
		FROM_TYPE(FFI_TYPE_SINT16, int16_t, alloc_int)
		FROM_TYPE(FFI_TYPE_UINT32, uint32_t, alloc_int)
		FROM_TYPE(FFI_TYPE_SINT32, int32_t, alloc_int)
		FROM_TYPE(FFI_TYPE_POINTER, uintptr_t, wrap_pointer)
		case FFI_TYPE_STRUCT: {
			uint size = 0;
			while(t -> elements[size] != NULL)
				size++;
			value obj = alloc_array(size);
			uintptr_t btrptr = (uintptr_t) ptr;
			for(uint i=0, off = 0; i < size; i++) {
				const ffi_type* curr = t -> elements[i];
				val_array_set_i(obj, i, from_pointer((void*) btrptr, (ffi_type*) curr));
				btrptr += curr -> size;
			}
			return obj;
		}
		case FFI_TYPE_SINT64:
		case FFI_TYPE_UINT64: {
			const value v = alloc_empty_object();
			const int64_t l = *((int64_t*) ptr);
			alloc_field(v, val_id("low"), alloc_int(l & 0xFFFFFFFF));
			alloc_field(v, val_id("high"), alloc_int(l >> 32));
			return v;
		}
		default:
			val_throw(alloc_string("Unrecognised type"));
			return alloc_null();
	}
}
value hx_ffi_get_val(value ptr) {
	return (value) val_data(ptr);
}
DEFINE_PRIM(hx_ffi_get_val, 1);
value hx_ffi_get_ptr(value ptr, value type, value off) {
	return from_pointer((void*) (unwrap_pointer(ptr) + val_int(off)), (ffi_type*) val_get_handle(type, k_ffi_type));
}
DEFINE_PRIM(hx_ffi_get_ptr, 3);
value hx_ffi_cif_call(value v_cif, value v_func, value v_args) {
	const ffi_cif* cif = (ffi_cif*) val_data(v_cif);
	void (*func)(void) = (void (*)()) val_data(v_func);
	const uint num_args = val_array_size(v_args);
	void* ret_space = malloc(cif -> rtype -> size);
	void** args = new void*[num_args];
	for(uint i = 0; i < num_args; i++) {
		args[i] = to_pointer(val_array_i(v_args, i), cif -> arg_types[i]);
	}
	ffi_call((ffi_cif*) cif, func, ret_space, args);
	return from_pointer(ret_space, cif -> rtype);
}
DEFINE_PRIM(hx_ffi_cif_call, 3);
const char* concat(const char* a, const char* b) {
	std::stringstream ss;
	ss << a << b;
	return ss.str().c_str();
}
value hx_ffi_load_library(value v_path) {
	const char* path = val_string(v_path);
	void* library;
	#ifdef UNIX
	library = dlopen(path, RTLD_LAZY);
	if(library == NULL)
		val_throw(alloc_string(dlerror()));
	#else
	library = LoadLibrary(path);
	val_throw(alloc_int(GetLastError()));
	#endif
	return library == NULL ? alloc_null() : alloc_abstract(k_library, library);
}
DEFINE_PRIM(hx_ffi_load_library, 1);
value hx_ffi_close_library(value v_lib) {
	void* lib = val_data(v_lib);
	#ifdef UNIX
	dlclose(lib);
	#else
	FreeLibrary(lib);
	#endif
	return alloc_null();
}
DEFINE_PRIM(hx_ffi_close_library, 1);
value hx_ffi_load_symbol(value v_lib, value v_sym) {
	const char* sym = val_string(v_sym);
	void* lib = val_data(v_lib);
	void* func;
	#ifdef UNIX
	func = dlsym(lib, sym);
	if(func == NULL)
		val_throw(alloc_string(dlerror()));
	#else
	#endif
	return alloc_abstract(k_function, func);
}
DEFINE_PRIM(hx_ffi_load_symbol, 2);

const value hx_ffi_get_str(const value ptr) {
	return alloc_string((const char*) val_data(ptr));
}
DEFINE_PRIM(hx_ffi_get_str, 1);

const value hx_ffi_from_str(const value str) {
	return wrap_pointer((const char*) val_string(str));
}
DEFINE_PRIM(hx_ffi_from_str, 1);

void hx_ffi_free(const value ptr) {
	free(val_data(ptr));
}
DEFINE_PRIM(hx_ffi_free, 1);