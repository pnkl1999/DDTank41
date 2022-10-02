package game.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapShape;
   import ddt.manager.BitmapManager;
   import flash.display.Sprite;
   
   public class AchievNumShape extends Sprite implements Disposeable
   {
       
      
      private var _bitmapMgr:BitmapManager;
      
      private var _numShapes:Vector.<BitmapShape>;
      
      public function AchievNumShape()
      {
         this._numShapes = new Vector.<BitmapShape>();
         super();
         visible = mouseChildren = mouseEnabled = false;
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function drawNum(param1:int) : void
      {
         var _loc2_:BitmapShape = this._numShapes.shift();
         while(_loc2_ != null)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = this._numShapes.shift();
         }
         var _loc3_:String = param1.toString();
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._bitmapMgr.creatBitmapShape("asset.game.achiev.num" + _loc3_.substr(_loc5_,1));
            if(_loc5_ > 0)
            {
               _loc2_.x = this._numShapes[_loc5_ - 1].x + this._numShapes[_loc5_ - 1].width;
            }
            addChild(_loc2_);
            this._numShapes.push(_loc2_);
            _loc5_++;
         }
         visible = true;
      }
   }
}
