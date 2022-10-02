package vip.view
{
	import bagAndInfo.info.LevelProgress;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.image.ScaleLeftRightImage;
	import com.pickgliss.utils.ObjectUtils;
	import flash.display.Graphics;
	
	public class VipLevelProgress extends LevelProgress
	{
		
		
		private var _backBG:ScaleLeftRightImage;
		
		public function VipLevelProgress()
		{
			super();
		}
		
		public function set progressLabelTextFormatStyle(param1:String) : void
		{
			_progressLabel.textFormatStyle = param1;
		}
		
		public function set progressLabelFilterString(param1:String) : void
		{
			_progressLabel.filterString = param1;
		}
		
		override protected function initView() : void
		{
			_thuck = ComponentFactory.Instance.creatComponentByStylename("VIP.thunck");
			addChildAt(_thuck,0);
			this._backBG = ComponentFactory.Instance.creatComponentByStylename("VIP.LeveLBG");
			addChildAt(this._backBG,0);
			_graphics_thuck = ComponentFactory.Instance.creatComponentByStylename("VIP.thuckBitData").getBitmapdata();
			_progressLabel = ComponentFactory.Instance.creatComponentByStylename("vipLevelProgressTxt");
			addChild(_progressLabel);
		}
		
		override protected function drawProgress() : void
		{
			var _loc1_:Number = _value / _max > 1 ? Number(Number(1)) : Number(Number(_value / _max));
			var _loc2_:Graphics = _thuck.graphics;
			_loc2_.clear();
			if(_loc1_ >= 0)
			{
				_progressLabel.text = Math.floor(_loc1_ * 10000) / 100 + "%";
				_loc2_.beginBitmapFill(_graphics_thuck);
				_loc2_.drawRect(0,0,_width * _loc1_,_height - 8);
				_loc2_.endFill();
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
			ObjectUtils.disposeObject(this._backBG);
			this._backBG = null;
		}
	}
}