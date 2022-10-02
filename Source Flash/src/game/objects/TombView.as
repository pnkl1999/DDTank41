package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   
   public class TombView extends PhysicalObj
   {
       
      
      private var _sp:Sprite;
      
      private var _asset:Bitmap;
      
      public function TombView()
      {
         super(-1,1,5,50);
         _testRect = new Rectangle(-3,3,6,3);
         _canCollided = true;
         this.initView();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get layer() : int
      {
         return PhysicsLayer.Tomb;
      }
      
      private function initView() : void
      {
         mouseEnabled = false;
         mouseChildren = false;
         this._asset = ComponentFactory.Instance.creatBitmap("asset.game.tombAsset");
         this._asset.x = -20;
         this._asset.y = -50;
         this._sp = new Sprite();
         this._sp.addChild(this._asset);
         this._sp.y = 3;
         addChild(this._sp);
      }
      
      override public function die() : void
      {
         super.die();
         _map.removePhysical(this);
      }
      
      override public function stopMoving() : void
      {
         super.stopMoving();
         this._sp.rotation = calcObjectAngle();
      }
      
      override public function dispose() : void
      {
         if(_map)
         {
            _map.removePhysical(this);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this._sp.removeChild(this._asset);
         this._asset.bitmapData.dispose();
         this._asset = null;
         removeChild(this._sp);
         this._sp = null;
         _testRect = null;
         super.dispose();
      }
   }
}
