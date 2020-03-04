function [binImage] = Binarize(IMF)

  % available methods
  % graythresh	Global image threshold using Otsu's method
  % multithresh	Multilevel image thresholds using Otsu’s method
  % otsuthresh	Global histogram threshold using Otsu's method
  % adaptthresh	Adaptive image threshold using local first - order statistics
  
  IMF.VPrintF('[IMF] Binarizing image...');

  binImage = normalize(IMF.filt);

  switch IMF.binMethod
  case 'gray' % this is basic otsu
    level = graythresh(binImage);
  case 'multi' % this is multi level otsu
    level = multithresh(binImage, IMF.nThreshLevels);
    level = level(1); % we take the lowest level for 'max' tresholding
  case 'adapt'
    level = adaptthresh(binImage, IMF.threshSens);
  end

  binImage = imbinarize(binImage, level);
end
