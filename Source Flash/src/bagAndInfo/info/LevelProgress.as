package bagAndInfo.info
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Component;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.utils.ObjectUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	public class LevelProgress extends Component
	{
		
		public static const Progress:String = "progress";
		
		
		protected var _background:Bitmap;
		
		protected var _thuck:Component;
		
		protected var _graphics_thuck:BitmapData;
		
		protected var _value:Number = 0;
		
		protected var _max:Number = 100;
		
		protected var _progressLabel:FilterFrameText;
		
		public function LevelProgress()
		{
			super();
			_width = _height = 10;
			this.initView();
			this.drawProgress();
		}
		
		protected function initView() : void
		{
			this._background = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.Background_Progress");
			addChild(this._background);
			this._thuck = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.thunck");
			addChild(this._thuck);
			this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("bagAndInfo.info.Bitmap_thuck");
			this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.LevelProgressText");
			addChild(this._progressLabel);
		}
		
		public function setProgress(param1:Number, param2:Number) : void
		{
			if(this._value != param1 || this._max != param2)
			{
				this._value = param1;
				this._max = param2;
				this.drawProgress();
			}
		}
		
		protected function drawProgress() : void
		{
			var _loc1_:Number = this._value / this._max > 1 ? Number(Number(1)) : Number(Number(this._value / this._max));
			var _loc2_:Graphics = this._thuck.graphics;
			_loc2_.clear();
			if(_loc1_ >= 0)
			{
				this._progressLabel.text = Math.floor(_loc1_ * 10000) / 100 + "%";
				_loc2_.beginBitmapFill(this._graphics_thuck);
				_loc2_.drawRect(0,0,(_width - 4) * _loc1_,_height - 4);
				_loc2_.endFill();
			}
		}
		
		public function set labelText(param1:String) : void
		{
			this._progressLabel.text = param1;
		}
		
		override public function dispose() : void
		{
			ObjectUtils.disposeObject(this._graphics_thuck);
			this._graphics_thuck = null;
			ObjectUtils.disposeObject(this._background);
			this._background = null;
			ObjectUtils.disposeObject(this._thuck);
			this._thuck = null;
			ObjectUtils.disposeObject(this._progressLabel);
			this._progressLabel = null;
			super.dispose();
		}
	}
}
