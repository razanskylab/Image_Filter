function [waveIm] = Calc_Wavelet_Transform(IMF)
  % Need to check what this is actually supposed to be doing, but I don't 
  % think this is working well for our vessel data...

  t1 = tic;
  levels = IMF.waveletLevels;
  IMF.VPrintF('Wavelet filtering using levels %i-%i...', levels(1), levels(end))


  % First smoothing level = input image
  sIn = normalize(IMF.filt);

  % Inititalise output
  waveIm = 0;

  % B3 spline coefficients for filter
  b3 = [1 4 6 4 1] / 16;

  if IMF.verbosePlotting
    [m,n] = find_subplot_dividers(max(levels)*2);
    figure();
  end

  % Compute transform
  for processLevel = levels
    % Create convolution kernel
    h = dilate_wavelet_kernel(b3, 2^(processLevel-1)-1);

    % Convolve and subtract to get wavelet level
    sFilt = imfilter(sIn, h' * h, 'symmetric');

    waveIm = waveIm + sIn - sFilt;

    % Update input for new iteration
    sIn = sFilt;
    if IMF.verbosePlotting
      subplot(m,n,2*processLevel-1);
      imagescj(sFilt);
      title(sprintf('Level: %i',processLevel));
      subplot(m,n,2*processLevel);
      imagescj(waveIm, 'gray');
    end
  end
  if IMF.verbosePlotting
    sub_plot_title('Wavelet Levels')
  end

  IMF.Done(t1);
end

function h2 = dilate_wavelet_kernel(h, spacing)
  % Dilates a wavelet kernel by entering SPACING zeros between each
  % coefficient of the filter kernel H.

  % Check input
  if ~isvector(h) && ~isscalar(spacing)
      error(['Invalid input to DILATE_WAVELET_KERNEL: ' ...
            'H must be a vector and SPACING must be a scalar']);
  end

  % Preallocate the expanded filter
  h2 = zeros(1, numel(h) + spacing * (numel(h) - 1));
  % Ensure output kernel orientation is the same
  if size(h,1) > size(h,2)
      h2 = h2';
  end
  % Put in the coefficients
  h2(1:spacing+1:end) = h;
end