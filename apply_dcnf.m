
function [depths_inpaint, img_data] = apply_dcnf(full_img_file, ds_config, opts, model_trained)

  opts_eval_i = opts;

  depths_inpaint = [];
  img_data=read_img_rgb(full_img_file);
  try
    img_data=read_img_rgb(full_img_file);
  catch ME
    warning(ME.message);
    return
  end

  if ~isempty(ds_config.max_img_edge)
    max_img_edge=ds_config.max_img_edge;

    img_size1=size(img_data, 1);
    img_size2=size(img_data, 2);


    if img_size1>img_size2
      if img_size1>max_img_edge
        img_data=imresize(img_data, [max_img_edge, NaN]);
      end
    else
      if img_size2>max_img_edge
        img_data=imresize(img_data, [NaN, max_img_edge]);
      end
    end
  end


  fprintf('generating superpixels...\n');
  sp_info=gen_supperpixel_info(img_data, ds_config.sp_size);

  fprintf('generating pairwise info...\n');
  pws_info=gen_feature_info_pairwise(img_data, sp_info);


  ds_info=[];
  ds_info.img_idxes=1;
  ds_info.img_data=img_data;
  ds_info.sp_info{1}=sp_info;
  ds_info.pws_info=pws_info;
  ds_info.sp_num_imgs=sp_info.sp_num;


  depths_pred = do_model_evaluate(model_trained, ds_info, opts_eval_i);


  fprintf('inpaiting using Anat Levin`s colorization code, this may take a while...\n');
  depths_inpaint = do_inpainting(depths_pred, img_data, sp_info);

  fprintf('%s Done\n', mfilename);
