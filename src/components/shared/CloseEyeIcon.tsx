import * as React from "react";
import Svg, { G, Path, Defs, ClipPath, Rect } from "react-native-svg";

type CloseEyeIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const CloseEyeIcon = ({ style, color, width, height }: CloseEyeIconProps) => (
  <Svg
    width={width || 25}
    height={height || 25}
    viewBox={`0 0 ${width || 25} ${height || 25}`}
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    style={style}
  >
    <G clipPath="url(#clip0_113_52)">
      <Path
        d="M17.9758 18.8311C16.2664 20.1341 14.1849 20.856 12.0358 20.8911C5.03583 20.8911 1.03583 12.8911 1.03583 12.8911C2.27972 10.573 4.00496 8.54775 6.09583 6.95114M9.93583 5.13114C10.6242 4.97002 11.3289 4.88948 12.0358 4.89114C19.0358 4.89114 23.0358 12.8911 23.0358 12.8911C22.4288 14.0267 21.7049 15.0959 20.8758 16.0811M14.1558 15.0111C13.8812 15.3059 13.55 15.5423 13.182 15.7063C12.814 15.8702 12.4167 15.9584 12.0139 15.9655C11.6111 15.9726 11.211 15.8985 10.8374 15.7476C10.4639 15.5967 10.1245 15.3722 9.83967 15.0873C9.5548 14.8024 9.33022 14.4631 9.17934 14.0895C9.02845 13.716 8.95435 13.3159 8.96146 12.913C8.96857 12.5102 9.05674 12.113 9.2207 11.745C9.38467 11.377 9.62108 11.0458 9.91583 10.7711"
        stroke={color || "#25273C"}
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <Path
        d="M1.03583 1.89111L23.0358 23.8911"
        stroke={color || "#25273C"}
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </G>
    <Defs>
      <ClipPath id="clip0_113_52">
        <Rect
          width={width || 25}
          height={height || 25}
          fill="white"
          transform="translate(0.0358276 0.891113)"
        />
      </ClipPath>
    </Defs>
  </Svg>
);
export default CloseEyeIcon;
