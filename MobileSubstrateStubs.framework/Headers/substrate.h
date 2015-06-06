#ifndef _SUBSTRATE

#define _SUBSTRATE

#ifdef __cplusplus
extern "C" {
#endif
#include <mach-o/nlist.h>
#ifdef __cplusplus
}
#endif

#include <string.h>
#include <sys/types.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#ifdef __cplusplus
#define _default(x) = x
extern "C" {
#else
#define _default(x)
#endif
	typedef const void *MSImageRef;
	void MSHookFunction(void *symbol, void *replace, void **result);
	void *MSFindSymbol(const void *image, const char *name);
	MSImageRef MSGetImageByName(const char *file);
	
#ifdef __APPLE__
#ifdef __arm__
	IMP MSHookMessage(Class _class, SEL sel, IMP imp, const char *prefix _default(NULL));
#endif
	void MSHookMessageEx(Class _class, SEL sel, IMP imp, IMP *result);
	
	
#endif
#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
template <typename Type_>
static inline void MSHookFunction(Type_ *symbol, Type_ *replace) {
	return MSHookFunction(symbol, replace, reinterpret_cast<Type_ **>(NULL));
}

template <typename Type_>
static inline void MSHookSymbol(Type_ *&value, const char *name, void *handle) {
	value = reinterpret_cast<Type_ *>(dlsym(handle, name));
}

template <typename Type_>
static inline Type_ &MSHookIvar(id self, const char *name) {
	Ivar ivar(class_getInstanceVariable(object_getClass(self), name));
	void *pointer(ivar == NULL ? NULL : reinterpret_cast<char *>(self) + ivar_getOffset(ivar));
	return *reinterpret_cast<Type_ *>(pointer);
}
#endif


#endif