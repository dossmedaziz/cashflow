import Svg, { G, Path, Defs, ClipPath, Rect } from "react-native-svg";

type EyeIconProps = {
  style?: object;
  color?: string;
  width?: number;
  height?: number;
};
const EyeIcon = ({ style, color, width, height }: EyeIconProps) => (
  <Svg
    width={width || 25}
    height={height || 25}
    viewBox={`0 0 ${width || 25} ${height || 25}`}
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    style={style}
  >
    <G clipPath="url(#clip0_113_49)">
      <Path
        d="M1.56793 12.6122C1.56793 12.6122 5.56793 4.61224 12.5679 4.61224C19.5679 4.61224 23.5679 12.6122 23.5679 12.6122C23.5679 12.6122 19.5679 20.6122 12.5679 20.6122C5.56793 20.6122 1.56793 12.6122 1.56793 12.6122Z"
        stroke={color || "#25273C"}
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <Path
        d="M12.5679 15.6122C14.2248 15.6122 15.5679 14.2691 15.5679 12.6122C15.5679 10.9554 14.2248 9.61224 12.5679 9.61224C10.9111 9.61224 9.56793 10.9554 9.56793 12.6122C9.56793 14.2691 10.9111 15.6122 12.5679 15.6122Z"
        stroke={color || "#25273C"}
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </G>
    <Defs>
      <ClipPath id="clip0_113_49">
        <Rect
          width={width || 25}
          height={height || 25}
          fill="white"
          transform="translate(0.567932 0.612244)"
        />
      </ClipPath>
    </Defs>
  </Svg>
);
export default EyeIcon;
