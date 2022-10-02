package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class GhostStarContainer extends Sprite implements Disposeable
   {
       
      
      private var _maxLv:Number = 10;
      
      private var _mask:Sprite;
      
      private var _content:Sprite;
      
      private var _bg:Sprite;
      
      public function GhostStarContainer()
      {
         super();
      }
      
      private function initContainer() : void
      {
         var _loc1_:* = undefined;
         var _loc3_:Bitmap = null;
         _loc1_ = 0;
         var _loc2_:Bitmap = null;
         _loc3_ = null;
         var _loc4_:uint = Math.ceil(this._maxLv / 2);
         this._content = new Sprite();
         this._bg = new Sprite();
         addChild(this._bg);
         addChild(this._content);
         _loc1_ = uint(0);
         while(_loc1_ < _loc4_)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.ddtcoreii.ghostGrayStar");
            _loc3_.x = _loc3_.width * _loc1_;
            this._bg.addChild(_loc3_);
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.ddtcoreii.ghostStar");
            _loc2_.x = _loc2_.width * _loc1_;
            this._content.addChild(_loc2_);
            _loc1_++;
         }
         this._mask = new Sprite();
         this._mask.graphics.beginFill(16777215,1);
         this._mask.graphics.drawRect(0,0,width,height);
         this._mask.graphics.endFill();
         cacheAsBitmap = true;
         this._content.mask = this._mask;
         this._content.addChild(this._mask);
      }
      
      public function set maxLv(param1:uint) : void
      {
         this._maxLv = param1;
      }
      
      public function set level(param1:uint) : void
      {
         if(param1 > this._maxLv)
         {
            return;
         }
         if(this._mask == null)
         {
            this.initContainer();
         }
         this._mask.width = param1 / this._maxLv * width;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._mask);
         this._mask = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
