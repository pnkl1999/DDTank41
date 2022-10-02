package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.display.BitmapObject;
   import ddt.display.BitmapShape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class BitmapManager implements Disposeable
   {
      
      public static const GameView:String = "GameView";
      
      private static const destPoint:Point = new Point();
      
      private static var _mgrPool:Object = new Object();
       
      
      private var _bitmapPool:Object;
      
      private var _len:int;
      
      public var name:String = "BitmapManager";
      
      public var linkCount:int = 0;
      
      public function BitmapManager()
      {
         super();
         this._bitmapPool = new Object();
      }
      
      public static function hasMgr(param1:String) : Boolean
      {
         return _mgrPool.hasOwnProperty(param1);
      }
      
      private static function registerMgr(param1:String, param2:BitmapManager) : void
      {
         _mgrPool[param1] = param2;
      }
      
      private static function removeMgr(param1:String) : void
      {
         if(hasMgr(param1))
         {
            delete _mgrPool[param1];
         }
      }
      
      public static function getBitmapMgr(param1:String) : BitmapManager
      {
         var _loc2_:BitmapManager = null;
         if(hasMgr(param1))
         {
            _loc2_ = _mgrPool[param1];
            ++_loc2_.linkCount;
            return _loc2_;
         }
         _loc2_ = new BitmapManager();
         _loc2_.name = param1;
         ++_loc2_.linkCount;
         registerMgr(param1,_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         --this.linkCount;
         if(this.linkCount <= 0)
         {
            this.destory();
         }
      }
      
      private function destory() : void
      {
         var _loc1_:* = null;
         var _loc2_:BitmapObject = null;
         removeMgr(this.name);
         for(_loc1_ in this._bitmapPool)
         {
            _loc2_ = this._bitmapPool[_loc1_];
            _loc2_.destory();
            delete this._bitmapPool[_loc1_];
         }
         this._bitmapPool = null;
      }
      
      public function creatBitmapShape(param1:String, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false) : BitmapShape
      {
         return new BitmapShape(this.getBitmap(param1),param2,param3,param4);
      }
      
      public function hasBitmap(param1:String) : Boolean
      {
         return this._bitmapPool.hasOwnProperty(param1);
      }
      
      public function getBitmap(param1:String) : BitmapObject
      {
         var _loc2_:BitmapObject = null;
         if(this.hasBitmap(param1))
         {
            _loc2_ = this._bitmapPool[param1];
            ++_loc2_.linkCount;
            return _loc2_;
         }
         _loc2_ = this.createBitmap(param1);
         _loc2_.manager = this;
         ++_loc2_.linkCount;
         return _loc2_;
      }
      
      private function createBitmap(param1:String) : BitmapObject
      {
         var _loc3_:BitmapObject = null;
         var _loc2_:* = ComponentFactory.Instance.creat(param1);
         if(_loc2_ is BitmapData)
         {
            _loc3_ = new BitmapObject(_loc2_.width,_loc2_.height,true,0);
            _loc3_.copyPixels(_loc2_,_loc2_.rect,destPoint);
            _loc3_.linkName = param1;
            this.addBitmap(_loc3_);
            return _loc3_;
         }
         if(_loc2_ is Bitmap)
         {
            _loc3_ = new BitmapObject(_loc2_.bitmapData.width,_loc2_.bitmapData.height,true,0);
            _loc3_.copyPixels(_loc2_.bitmapData,_loc2_.bitmapData.rect,destPoint);
            _loc3_.linkName = param1;
            this.addBitmap(_loc3_);
            return _loc3_;
         }
         if(_loc2_ is DisplayObject)
         {
            _loc3_ = new BitmapObject(_loc2_.width,_loc2_.height,true,0);
            _loc3_.draw(_loc2_ as IBitmapDrawable);
            _loc3_.linkName = param1;
            this.addBitmap(_loc3_);
            return _loc3_;
         }
         return null;
      }
      
      private function addBitmap(param1:BitmapObject) : void
      {
         if(!this.hasBitmap(param1.linkName))
         {
            ++this._len;
         }
         param1.linkCount = 0;
         param1.manager = this;
         this._bitmapPool[param1.linkName] = param1;
      }
      
      private function removeBitmap(param1:BitmapObject) : void
      {
         if(this.hasBitmap(param1.linkName))
         {
            --this._len;
         }
         delete this._bitmapPool[param1.linkName];
      }
   }
}
