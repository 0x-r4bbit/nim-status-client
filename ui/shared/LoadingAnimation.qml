import QtQuick 2.13

import utils 1.0
import "../shared/panels"

SVGImage {
    id: loadingImg
    source: Style.svg("loading")
    width: 25
    height: 25
    fillMode: Image.Stretch
    RotationAnimator {
        target: loadingImg;
        from: 0;
        to: 360;
        duration: 1200
        running: true
        loops: Animation.Infinite
    }
}
