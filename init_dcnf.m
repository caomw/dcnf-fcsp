
function [model_trained, opts, ds_config] = init_dcnf(img_type, model_dir, varargin)

  opts=[];
  ds_config=[];

  this_dir = fileparts(mfilename);

  %settings we used for training our model:
  % 1. sp_size: average superpixel size in SLIC
  % 2. max_img_edge: resize the image with the largest edge <= max_img_edge
  if strcmp(img_type, 'outdoor')
    ds_config.sp_size=16;
    ds_config.max_img_edge=600;

    %outdoor scene model
    trained_model_file=fullfile(model_dir, 'model_dcnf-fcsp_Make3D');
  end

  if strcmp(img_type, 'indoor')
    ds_config.sp_size=20;
    ds_config.max_img_edge=640;

    %indoor scene model
    trained_model_file=fullfile(model_dir, 'model_dcnf-fcsp_NYUD2');
  end

  opts.useGpu = false; % disable gpu by default
  opts = vl_argparse(opts, varargin);

  if opts.useGpu
    if gpuDeviceCount==0
      disp('WARNNING!!!!!! no GPU found!');
      disp('any key to continue...');
      pause;
      opts.useGpu=false;
    end
  end

  fprintf('\nloading trained model...\n\n');

  model_trained=load(trained_model_file);
  model_trained=model_trained.data_obj;

  if strcmpi(img_type, 'indoor')
    opts.do_show_log_scale=false;
  end

  if strcmpi(img_type, 'outdoor')
    opts.do_show_log_scale=true;
  end
  opts.result_dir=[];

end
