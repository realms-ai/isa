class NseBsStrategy < ActiveRecord::Base
belongs_to :Nse_stock
validates :stock_name, uniqueness: true

	def self.strategy1
		#For best BUYERS
		data = NseTrend.where("d3_t = 3").order("avg_high desc").limit(30)
		st = 1
		data.each do |d|
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 1)
			st += 1
		end	

		#For best sellers
		data = NseTrend.where("d3_t = -3").order("avg_low asc").limit(30)
		st = 1
		data.each do |d|				
			if d.avg_low < -10
				if d.avg_high < 0
					d.avg_high = -1 if d.avg_high < -1
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
					d.avg_high = -1 if d.avg_high < -1
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 1)
			st += 1
		end		
	end

	def self.strategy2
		#For best BUYERS
		data = NseTrend.where("d3_t = 1 AND d7_t > 0").order("avg_high desc").limit(30)
		st = 1
		data.each do |d|
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 2)
			st += 1
		end	

		#For best sellers
		data = NseTrend.where("d3_t = -1 AND d7_t < 0").order("avg_low asc").limit(30)
		st = 1
		data.each do |d|				
			if d.avg_low < -10
				if d.avg_high < 0
					d.avg_high = -1 if d.avg_high < -1
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 2)
			st += 1
		end			
	end

	def self.strategy3
		#For best BUYERS
		data = NseTrend.where("d3_t = -1 AND d7_t > 0 AND d15_t > 0").order("avg_high desc").limit(30)
		st = 1
		data.each do |d|
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 3)
			st += 1
		end	

		#For best sellers
		data = NseTrend.where("d3_t = 1 AND d7_t < 0 AND d15_t < 0").order("avg_low asc").limit(30)
		st = 1
		data.each do |d|				
			if d.avg_low < -10
				if d.avg_high < 0
					d.avg_high = -1 if d.avg_high < -1
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
			NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
				:high => (d.last_close * (1 + (d.avg_high / 100))), 
				:low => (d.last_close * (1 + (d.avg_low / 100))),
				:close => (d.last_close * (1 + (d.avg_close / 100))),
				:target_1 => target1, :stop_loss_1 => stop_loss1,
				:target_2 => target2, :stop_loss_2 => stop_loss2,
				:target_3 => target3, :stop_loss_3 => stop_loss3,
				:rank => st, :strategy => 1)
			st += 1
		end		
	end
end