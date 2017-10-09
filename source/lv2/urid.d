module lv2.urid;

import lv2.bind.urid;
import lv2.core;


alias URID = uint;

@nogc nothrow
struct Map
{
    enum uri = LV2_URID__map;

    static Map from_data(void *data) {
        return Map (cast(LV2_URID_Map*)data);
    }

    URID map(string uri)
    {
        import lv2.util : CStr;
        auto curi = CStr(uri);
        return native.map(native.handle, curi);
    }

    private LV2_URID_Map* native;

}
