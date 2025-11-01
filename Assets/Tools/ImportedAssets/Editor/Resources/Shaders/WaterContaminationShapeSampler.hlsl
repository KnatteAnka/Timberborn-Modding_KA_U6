#define UV_00 0.0
#define UV_03 0.33333333333
#define UV_06 0.66666666666
#define UV_10 1.0

shared static const float4 ContaminationShapeUVOffsets[9] =
{
    float4(UV_00, UV_03, UV_00, UV_03),
    float4(UV_00, UV_03, UV_03, UV_06),
    float4(UV_00, UV_03, UV_06, UV_10),
    float4(UV_03, UV_06, UV_00, UV_03),
    float4(UV_03, UV_06, UV_03, UV_06),
    float4(UV_03, UV_06, UV_06, UV_10),
    float4(UV_06, UV_10, UV_00, UV_03),
    float4(UV_06, UV_10, UV_03, UV_06),
    float4(UV_06, UV_10, UV_06, UV_10),
};

void GetContaminationShapeUVAndMask_float(float index, out float2 uOffsetRange, out float2 vOffsetRange, out float mask)
{
    uOffsetRange = float2(0, 0);
    vOffsetRange = float2(0, 0);
    mask = 0;
    if (index > 0)
    {
        int indexAsByte = (255 * index) - 1;
        uOffsetRange = ContaminationShapeUVOffsets[indexAsByte].xy;
        vOffsetRange = ContaminationShapeUVOffsets[indexAsByte].zw;
        mask = 1;
    }
        
}