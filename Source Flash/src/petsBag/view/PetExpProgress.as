package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PetExperience;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class PetExpProgress extends Component
   {
       
      
      private var _gpItem:ScaleLeftRightImage;
      
      private var _maxGpItem:ScaleLeftRightImage;
      
      private var _gpMask:Shape;
      
      private var _maxGpMask:Shape;
      
      private var _gp:Number = 0;
      
      private var _maxGp:Number = 100;
      
      private var _progressLabel:FilterFrameText;
      
      public function PetExpProgress()
      {
         super();
         _height = 10;
         _width = 10;
         this.initView();
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      private function initView() : void
      {
         this._gpItem = ComponentFactory.Instance.creatComponentByStylename("petsBag.thuck.Graphic");
         addChild(this._gpItem);
         this._gpMask = this.creatMask(this._gpItem);
         addChild(this._gpMask);
         this._maxGpItem = ComponentFactory.Instance.creatComponentByStylename("petsBag.thuck.maxGraphic");
         addChild(this._maxGpItem);
         this._maxGpMask = this.creatMask(this._maxGpItem);
         addChild(this._maxGpMask);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.info.LevelProgressText");
         addChild(this._progressLabel);
      }
      
      private function creatMask(param1:DisplayObject) : Shape
      {
         var _loc2_:Shape = null;
         _loc2_ = null;
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16711680,1);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         param1.mask = _loc2_;
         return _loc2_;
      }
      
      public function setProgress(param1:Number, param2:Number) : void
      {
         if(this._gp != param1 || this._maxGp != param2)
         {
            this._gp = param1;
            this._maxGp = param2;
            this.drawProgress();
         }
      }
      
      public function noPet() : void
      {
         this._maxGpItem.visible = false;
         this._gpItem.visible = false;
         this._progressLabel.visible = false;
      }
      
      private function drawProgress() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = PetExperience.getLevelByGP(this._gp);
         var _loc2_:int = this._gp - PetExperience.expericence[_loc1_ - 1];
         _loc3_ = PetExperience.expericence[_loc1_ >= PetExperience.MAX_LEVEL ? PetExperience.MAX_LEVEL - 1 : _loc1_] - PetExperience.expericence[_loc1_ - 1];
         var _loc4_:int = this._maxGp - this._gp;
         var _loc5_:Number = _loc3_ == 0 ? Number(Number(0)) : Number(Number(_loc2_ / _loc3_));
         var _loc6_:Number = _loc3_ == 0 ? Number(Number(0)) : Number(Number((_loc2_ + _loc4_) / _loc3_));
         this._gpMask.width = this._gpItem.width * _loc6_;
         this._maxGpMask.width = this._maxGpItem.width * _loc5_;
         _tipData = [_loc2_,_loc3_].join("/") + LanguageMgr.GetTranslation("ddt.petbag.petExpProgressTip",_loc4_);
         this._progressLabel.text = [_loc2_,_loc3_].join("/");
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._gpItem);
         this._gpItem = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._gpItem);
         this._gpItem = null;
         ObjectUtils.disposeObject(this._maxGpItem);
         this._maxGpItem = null;
         ObjectUtils.disposeObject(this._gpMask);
         this._gpMask = null;
         ObjectUtils.disposeObject(this._maxGpMask);
         this._maxGpMask = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
