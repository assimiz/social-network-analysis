%process the results from playVotingGame and plots.
% results = matrix of the following format: 
% 	result_map(:, 1) = elite_size;	
%	result_map(:, 2) = dislike_voters;
%	result_map(:, 3) = neutral_voters;
%	result_map(:, 4) = like_voters;
%   (see result of playVotingGame)
% title = file name of links file (see majrityVoteSim) to be used for plot title
% figurefilename = file name for the chart
% charttitle = title for the chart 
% axismode = to be used for plot title. must be one of 'linear' or 'log'.
% determines if elite size will be sampled on linear or log scale
function proc_results = processResults(results, figurefilename, charttitle, axismode, n, m)

%total should be the same for all rows
total = sum(results(1, 2:end));

if strcmp(axismode, 'linear') == 1
	proc_results = results / total * 100;
elseif strcmp(axismode, 'log') == 1
	proc_results = log10(results) / log10(total)
	proc_results(find(proc_results == -Inf)) = 0;
elseif strcmp(axismode, 'x-log-y-linear') == 1
	proc_results(:,1) = log10(results(:, 1)) / log10(total);
	proc_results(:, 2:1:size(results, 2)) = results(:, 2:1:size(results, 2)) / total * 100;
else
	fprintf('ERROR: undefined steps mode for result processing. Use either linear or log \n');
end

fprintf('Plotting...\n');
figure;
hold on;
title(charttitle);
area_handle = 0;
X = proc_results(:, 1);
if strcmp(axismode, 'linear') == 1
	area_handle = area(X, proc_results(:, size(results, 2):-1:2));
	xlabel ('elite size (%)');
	ylabel ('voters (%)');
	color = [.8 .8 1];
	axis([0 100 0 100]);
	plot(X, X, 'LineWidth', 2, 'Color', color);
	plot(get(gca,'XLim'),[50 50],'k--');  % Plot dashed line
elseif strcmp(axismode, 'log') == 1	
	area_handle = area(X, proc_results(:, 2));
	set(area_handle(1), 'FaceColor', 'red');
	area_handle = area(X, proc_results(:, 3));
	set(area_handle(1), 'FaceColor', 'green');
	area_handle = area(X, proc_results(:, 4));
	set(area_handle(1), 'FaceColor', 'blue');
	xlabel ('elite size (n^x)');
	ylabel ('voters (n^x)');
	color = [.8 .8 1];
	axis([0 1 0 1]);
	plot(X, X, 'LineWidth', 2, 'Color', color);
	%plot vertical line on x where n^x = m^.5
	%calculate x where n^x = m^.5
	%x = log_n(m^.5) = log(m^.5) / log(n)
	x = log(m^.5) / log(n);
	plot([x x],get(gca,'YLim'),'k--');  % Plot dashed line
	%plot horizonta line on y where n^y = n/2
	%calculate y where n^y = n/2
	%y = log_n(n/2) = log(n/2) / log(n)
	y = log(n/2) / log(n);
	plot(get(gca,'XLim'),[y y],'k--');  % Plot dashed line
	%plot(x_val,y_val,'r*');     % Mark intersection with red asterisk
elseif strcmp(axismode, 'x-log-y-linear') == 1	
	area_handle = area(X, proc_results(:, size(results, 2):-1:2));
	xlabel ('elite size (n^x)');
	ylabel ('voters (%)');
	color = [.8 .8 1];
	axis([0 1 0 100]);
	plot(X, results(:, 1) / total * 100, 'LineWidth', 2, 'Color', color);
	%plot vertical line on x where n^x = m^.5
	%calculate x where n^x = m^.5
	%x = log_n(m^.5) = log(m^.5) / log(n)
	x = log(m^.5) / log(n);
	plot([x x],get(gca,'YLim'),'k--');  % Plot dashed line
	plot(get(gca,'XLim'),[50 50],'k--');  % Plot dashed line
else
	fprintf('ERROR: undefined axismode for result processing. Use either linear or log \n');
end

if strcmp(axismode, 'linear') == 1
	legend_handle = legend ('Like', 'Neutral', 'Dislike', 'Initial Like Voters', 'location', 'northwest');
	% legend ('Like', 'Neutral+Dislike', 'Initial Like Voters', 'location', 'eastoutside');
    % set(legend_handle, 'Color', 'none');
elseif strcmp(axismode, 'log') == 1
	legend_handle = legend ('Dislike', 'Neutral', 'Like', 'Initial Like Voters', 'location', 'northwest');
	% legend ('Like', 'Neutral+Dislike', 'Initial Like Voters', 'location', 'northwest');    
%     set(legend_handle, 'Color', [.7 .9 .7]);
elseif strcmp(axismode, 'x-log-y-linear') == 1
	legend_handle = legend ('Like', 'Neutral', 'Dislike', 'Initial Like Voters', 'location', 'northwest');
	% legend ('Like', 'Neutral+Dislike', 'Initial Like Voters', 'location', 'northwest');    
%     set(legend_handle, 'Color', [.7 .9 .7]);
else
	fprintf('ERROR: undefined axismode for result processing. Use either linear or log \n');
end

% set(legend_handle,'TextColor',[0, 0, 0]);
legend('boxon');


print('-dpng', figurefilename);
