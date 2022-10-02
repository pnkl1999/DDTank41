package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Graphics;
   import vip.view.VipLevelProgress;
   
   public class NecklaceLevelProgress extends VipLevelProgress
   {
       
      
      private var _backBG:ScaleLeftRightImage;
      
      public function NecklaceLevelProgress()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _thuck = ComponentFactory.Instance.creatComponentByStylename("NecklacePtetrochemicalView.thunck");
         addChildAt(_thuck,0);
         this._backBG = ComponentFactory.Instance.creatComponentByStylename("NecklacePtetrochemicalView.LeveLBG");
         addChildAt(this._backBG,0);
         _graphics_thuck = ComponentFactory.Instance.creatComponentByStylename("NecklacePtetrochemicalView.thuckBitData").getBitmapdata();
         _progressLabel = ComponentFactory.Instance.creatComponentByStylename("NecklaceProgressTxt");
         addChild(_progressLabel);
      }
      
      override protected function drawProgress() : void
      {
         var _loc1_:Number = _value / _max > 1?Number(1):Number(_value / _max);
         var _loc2_:Graphics = _thuck.graphics;
         _loc2_.clear();
         if(_loc1_ >= 0)
         {
            _progressLabel.text = _value.toString() + "/" + _max.toString();
            _loc2_.beginBitmapFill(_graphics_thuck);
            _loc2_.drawRect(0,0,_width * _loc1_,_height - 8);
            _loc2_.endFill();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._backBG);
         this._backBG = null;
         super.dispose();
      }
   }
}
