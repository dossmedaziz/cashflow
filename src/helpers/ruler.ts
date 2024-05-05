import { Dimensions, PixelRatio } from 'react-native';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

const aspectRatio = SCREEN_HEIGHT / SCREEN_WIDTH;
const isPhone = aspectRatio > 1.6;
const baseWidth = isPhone ? 375 : 430;
const baseHeight = 932;

/**generate new size using pixel ratio*/
const normalize = (size: number) => {
  const scale = SCREEN_WIDTH / baseWidth;
  const responsiveSize = size * scale;
  return responsiveSize;
}

/**vertical scale a size using pixel ratio*/
const verticalScale = (size: number) => {
  const scale = SCREEN_HEIGHT / baseHeight;
  const responsiveSize = size * scale;
  return responsiveSize;
};

/**generate device fit dimension width using percentage*/
const widthPercentageToDP = (widthPercent: number | string) => {
  const elemWidth = typeof widthPercent === 'number' ? widthPercent : parseFloat(widthPercent);
  return PixelRatio.roundToNearestPixel((SCREEN_WIDTH * elemWidth) / 100);
};

/**generate device fit dimension height using percentage*/
const heightPercentageToDP = (heightPercent: number | string) => {
  const elemHeight = typeof heightPercent === 'number' ? heightPercent : parseFloat(heightPercent);
  return PixelRatio.roundToNearestPixel((SCREEN_HEIGHT * elemHeight) / 100);
};

const moderateScale = (size : number, factor = 0.5) => size + (normalize(size) - size) * factor;


export { normalize, verticalScale as vs, widthPercentageToDP as wp, heightPercentageToDP as hp ,moderateScale};
