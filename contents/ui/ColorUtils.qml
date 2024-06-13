import QtQuick 6.6

Item {
    component Gradien: Item {
        /**
        ** Generate gradient with better colors than simple linear interpolation
        ** @see https://stackoverflow.com/questions/22607043/_color-gradient-algorithm
        ** Mark Ransom response : 
        ** The intensity of the gradient must be constant in a perceptual _color space 
        ** or it will look unnaturally dark or light at points in the gradient. 
        ** You can see this easily in a gradient based on simple interpolation of the sRGB values, 
        ** particularly the red-green gradient is too dark in the middle. Using interpolation on linear values 
        ** rather than gamma-corrected values makes the red-green gradient better, but at the expense of the back-white gradient. 
        ** By separating the light intensities from the _color you can get the best of both worlds.
        ** Often when a perceptual _color space is required, the Lab _color space will be proposed. 
        ** I think sometimes it goes too far, because it tries to accommodate the perception that blue 
        ** is darker than an equivalent intensity of other colors such as yellow. This is true, but we are used to seeing this effect in our natural environment and in a gradient you end up with an overcompensation.
        ** A power-law function of 0.43 was experimentally determined by researchers to be the best fit for relating gray light intensity to perceived brightness.
        **/
        function generateGradient(cold, hot, mix){
            var c1s = inverseSrgbCompanding(cold)
            var c2s = inverseSrgbCompanding(hot)

            var newR = interpolateLinear(c1s.r,c2s.r,mix)
            var newG = interpolateLinear(c1s.g,c2s.g,mix)
            var newB = interpolateLinear(c1s.b,c2s.b,mix)

            // Compute a measure of brightness of the two colors using empirically determined gamma
            var gamma =  0.43
            var brightness1 = Math.pow(c1s.r+c1s.g+c1s.b, gamma)
            var brightness2 = Math.pow(c2s.r+c2s.g+c2s.b, gamma)

            // Interpolate a new brightness value, and convert back to linear light
            var brightness = interpolateLinear(brightness1, brightness2, mix)
            var intensity = Math.pow(brightness, 1/gamma)

            // Apply adjustment factor to each rgb value based
            if ((newR+newG+newB) != 0) {
                var factor = intensity / (newR+newG+newB)
                newR = newR * factor
                newG = newG * factor
                newB = newB * factor
            }
            var rgb = {
                r: newR,
                g: newG,
                b: newB
            }
            var newRGB = srgbCompanding(rgb)
            var newColor = Qt.rgba(newRGB.r,newRGB.g,newRGB.b,1)
            return newColor
        }
        /**
            ** Convert _color from 0..255 to 0..1
            **/
        function normalize(_color){
            return {
                r : _color.r / 255,
                g : _color.g / 255,
                b : _color.b / 255,
            }
        }
        /**
            ** Apply sRGB companding to convert each channel into linear light
            **/
        function srgbCompanding(_color){
            var newR = 0
            var newG = 0
            var newB = 0

            // Apply companding to Red, Green, and Blue
            if (_color.r > 0.0031308) {newR = 1.055*Math.pow(_color.r, 1/2.4)-0.055} else {newR = _color.r * 12.92;}
            if (_color.g > 0.0031308) {newG = 1.055*Math.pow(_color.g, 1/2.4)-0.055} else {newG = _color.g * 12.92;}
            if (_color.b > 0.0031308) {newB = 1.055*Math.pow(_color.b, 1/2.4)-0.055} else {newB = _color.b * 12.92;}
            return {
                r : newR,
                g : newG,
                b : newB,
            }
        }
        /**
            ** Apply inverse sRGB companding to convert each channel into linear light
            **/
        function inverseSrgbCompanding(_color){
            var newR = 0.0
            var newG = 0.0
            var newB = 0.0
            // Apply companding to Red, Green, and Blue
            if (_color.r > 0.04045) {
                newR = Math.pow((_color.r+0.055)/1.055, 2.4)
            } else {
                newR = _color.r / 12.92;
            }
            if (_color.g > 0.04045) {
                newG = Math.pow((_color.g+0.055)/1.055, 2.4)

            } else {
                newG = _color.g / 12.92;
            }
            if (_color.b > 0.04045) {
                newB = Math.pow((_color.b+0.055)/1.055, 2.4)
            } else {
                newB = _color.b / 12.92;
            }
            
            return {
                r : newR,
                g : newG,
                b : newB,
            }
        }
        /**
            ** Linearly interpolate values using mix (0..1)
            **/
        function interpolateLinear(c1, c2, mix){
            return c1 * (1-mix) + c2 * mix
        }
    }
}
    