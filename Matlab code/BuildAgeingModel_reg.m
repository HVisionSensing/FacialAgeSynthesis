function [ Model ] = BuildAgeingModel_reg( textures, AppearanceModel, subjectlist, subj_numbers )
%BuildAgeingModel Finds the ageing model based on the images
%   Fits a model for the ages based on appearance parameters.  The
%   subject numbers for the images are in a separate variable as there is
%   more than one image per subject
%   The output is a model from which the coefficients can be taken
    
    % Using an approximation to the subjects age by assuming the pictures
    % were taken the year that the paper was published, and calculating the
    % age as year taken - birth year
    YEAR_TAKEN = 2008;
    
    subjlist_num = subjectlist(:,1);
    subjlist_year = subjectlist(:,2);
    
    app_params = zeros(size(textures,1), size(AppearanceModel.modes,2));
    ages = zeros(size(textures,1),1);
    
    for i=1:size(textures,1)
        app_params(i,:) = FindModelParameters(AppearanceModel, textures(i,:));
        birthyear = subjlist_year(subjlist_num==subj_numbers(i));
        ages(i) = YEAR_TAKEN - birthyear;
        
%         load('C:\datasetageing.mat', 'mask')
%         subplot(1,2,1), subimage(AddZerosToImage(mask, AppearanceParams2Texture(app_params(i,:)', AppearanceModel))/255);
%         subplot(1,2,2), subimage(AddZerosToImage(mask, textures(i,:))/255);
    end
    
     % Perform feature scaling
    Model.Transform.offset = mean(app_params);
    Model.Transform.scale = std(app_params);
    app_params = (app_params-repmat(Model.Transform.offset, size(app_params,1), 1))./repmat(Model.Transform.scale, size(app_params,1), 1);

%     Model.mdl = fitlm([app_params, app_params.^2], ages);
%     [Model.coeffs_all, Model.FitInfo] = lasso([app_params, app_params.^2], ages, 'Lambda', lambda);
    [Model.coeffs_all, Model.FitInfo] = lasso([app_params, app_params.^2], ages);
%     Model.offset = Model.FitInfo.Intercept;
%     Model.coeffs(:,1) = Model.coeffs_all(1:end/2);
%     Model.coeffs(:,2) = Model.coeffs_all(end/2+1:end);
   
%     Model = PolyRegression(app_params, ages, alpha, lambda);
end

