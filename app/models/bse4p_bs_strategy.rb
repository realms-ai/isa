class Bse4pBsStrategy < ActiveRecord::Base
	belongs_to :bse_stock

	def self.strategy1
		dates = Bse4pTrend.where("bse_stock_id = 5 and date > '2014-02-28'").collect(&:date).sort
		#For best buyers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = 3", date).order("avg_high desc").limit(30)
			for st in 1..data.count
				d = data[st-1]
				if d.avg_high > 10
					if d.avg_low > 0
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close * 1.01
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.03
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.025
					else
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.02
					end
				else
					if d.avg_low > 0
						d.avg_low = 1 if d.avg_low > 1
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.low > stop_loss3
					pl = (new_d.close - new_d.open) * shares_bought
				elsif new_d.low < stop_loss3 and new_d.low > stop_loss2
					pl = (stop_loss3 - new_d.open) * shares_bought
				elsif new_d.low < stop_loss2 and new_d.low > stop_loss1
					pl = (stop_loss2 - new_d.open) * shares_bought
				else
					pl = (stop_loss1 - new_d.open) * shares_bought
				end
				Bse4pBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => 1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 1)
			end
		end

		#For best sellers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = -3", date).order("avg_low asc").limit(30)
			for st in 1..data.count
				d = data[st-1]				
				if d.avg_low < -10
					if d.avg_high < 0
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close * 0.99
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.97
					elsif d.avg_high > 0 and d.avg_low < 1
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.975
					else
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.98
					end
				else
					if d.avg_high < 0
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
					elsif d.avg_high > 0 and d.avg_high < 1
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.high > stop_loss3
					pl = (new_d.open - new_d.close) * shares_bought
				elsif new_d.high > stop_loss2 and new_d.high < stop_loss3
					pl = (new_d.open - stop_loss3) * shares_bought
				elsif new_d.high > stop_loss1 and new_d.high < stop_loss2
					pl = (new_d.open - stop_loss2) * shares_bought
				else
					pl = (new_d.open - stop_loss1) * shares_bought
				end
				Bse4pBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => -1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 1)				
			end
		end		
	end

	def self.strategy2
		dates = Bse4pTrend.where("bse_stock_id = 5").collect(&:date).sort
		#For best buyers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = 3", date).order("avg_high desc").limit(30)
			for st in 1..data.count
				d = data[st-1]
				if d.avg_high > 10
					if d.avg_low > 0
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close * 1.01
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.03
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.025
					else
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.02
					end
				else
					if d.avg_low > 0
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.low > stop_loss3
					pl = (new_d.close - new_d.open) * shares_bought
				elsif new_d.low < stop_loss3 and new_d.low > stop_loss2
					pl = (stop_loss3 - new_d.open) * shares_bought
				elsif new_d.low < stop_loss2 and new_d.low > stop_loss1
					pl = (stop_loss2 - new_d.open) * shares_bought
				else
					pl = (stop_loss1 - new_d.open) * shares_bought
				end
				Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => 1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 1)
			end
		end

		#For best sellers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = -3", date).order("avg_low asc").limit(30)
			for st in 1..data.count
				d = data[st-1]				
				if d.avg_low < -10
					if d.avg_high < 0
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close * 0.99
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.97
					elsif d.avg_high > 0 and d.avg_low < 1
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.975
					else
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.98
					end
				else
					if d.avg_high < 0
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
					elsif d.avg_high > 0 and d.avg_high < 1
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.high > stop_loss3
					pl = (new_d.open - new_d.close) * shares_bought
				elsif new_d.high > stop_loss2 and new_d.high < stop_loss3
					pl = (new_d.open - stop_loss3) * shares_bought
				elsif new_d.high > stop_loss1 and new_d.high < stop_loss2
					pl = (new_d.open - stop_loss2) * shares_bought
				else
					pl = (new_d.open - stop_loss1) * shares_bought
				end
				Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => -1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 2)				
			end
		end		
	end

	def self.strategy3
		dates = Bse4pTrend.where("bse_stock_id = 5").collect(&:date).sort
		#For best buyers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = 3", date).order("avg_high desc").limit(30)
			for st in 1..data.count
				d = data[st-1]
				if d.avg_high > 10
					if d.avg_low > 0
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close * 1.01
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.03
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.025
					else
						target1 = d.last_close * 1.02
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * 1.035
						stop_loss2 = d.last_close 
						target3 = d.last_close * 1.05
						stop_loss3 = d.last_close * 1.02
					end
				else
					if d.avg_low > 0
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
						target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.low > stop_loss3
					pl = (new_d.close - new_d.open) * shares_bought
				elsif new_d.low < stop_loss3 and new_d.low > stop_loss2
					pl = (stop_loss3 - new_d.open) * shares_bought
				elsif new_d.low < stop_loss2 and new_d.low > stop_loss1
					pl = (stop_loss2 - new_d.open) * shares_bought
				else
					pl = (stop_loss1 - new_d.open) * shares_bought
				end
				Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => 1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 1)
			end
		end

		#For best sellers
		dates.each do |date|
		#date = dates[0]
			data = Bse4pTrend.where("date = ? AND d3_t = -3", date).order("avg_low asc").limit(30)
			for st in 1..data.count
				d = data[st-1]				
				if d.avg_low < -10
					if d.avg_high < 0
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close * 0.99
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.97
					elsif d.avg_high > 0 and d.avg_low < 1
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.975
					else
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.98
					end
				else
					if d.avg_high < 0
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
					elsif d.avg_high > 0 and d.avg_high < 1
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
					else
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
					end
				end
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				shares_bought = (10000 / new_d.open).to_i
				if new_d.high > stop_loss3
					pl = (new_d.open - new_d.close) * shares_bought
				elsif new_d.high > stop_loss2 and new_d.high < stop_loss3
					pl = (new_d.open - stop_loss3) * shares_bought
				elsif new_d.high > stop_loss1 and new_d.high < stop_loss2
					pl = (new_d.open - stop_loss2) * shares_bought
				else
					pl = (new_d.open - stop_loss1) * shares_bought
				end
				Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:date => d.date, :executed_date => new_d.date, :last_close => d.last_close,
					:bs_signal => -1, :open => new_d.open, :high => new_d.high, 
					:low => new_d.low, :close => new_d.close, :target_1 => target1, 
					:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
					:rank => st, :strategy => 1)				
			end
		end		
	end
end