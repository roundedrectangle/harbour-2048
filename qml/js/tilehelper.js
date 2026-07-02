.import '../Game/mathutils.js' as MathUtils

function getTileOpacity(value) {
    if (value <= 0)
        return 0
    if (value > 8192)
        return 1
    var values = [0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.65, 0.70, 0.85, 0.90]
    var value = values[MathUtils.log2(value) - 1]
    return typeof value !== 'undefined' ? value : 1
}
