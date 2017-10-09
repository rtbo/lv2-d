module lv2.bind.urid;

enum LV2_URID_URI = "http://lv2plug.in/ns/ext/urid";

enum LV2_URID__map = "http://lv2plug.in/ns/ext/urid#map";
enum LV2_URID__unmap = "http://lv2plug.in/ns/ext/urid#unmap";

alias LV2_URID_Map_Handle = void*;
alias LV2_URID_Unmap_Handle = void*;

alias LV2_URID = uint;

extern(C)
struct LV2_URID_Map
{
    LV2_URID_Map_Handle handle;

    LV2_URID function (LV2_URID_Map_Handle handle,
                       const char*         uri)
            map;
}

extern(C)
struct LV2_URID_Unmap
{
    LV2_URID_Unmap_Handle handle;

    const (char)* function (LV2_URID_Unmap_Handle handle,
                           LV2_URID              urid)
            unmap;
}
