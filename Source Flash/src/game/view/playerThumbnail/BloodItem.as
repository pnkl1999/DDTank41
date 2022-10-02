package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import game.model.Living;
   
   public class BloodItem extends Sprite implements Disposeable
   {
       
      
      private var _width:int;
      
      private var _totalBlood:int;
      
      private var _bloodNum:int;
      
      private var _bg:Bitmap;
      
      private var _HPStrip:Bitmap;
      
      private var _healthShape:Shape;
      
      private var _visibleRect:Rectangle;
      
      private var _living:Living;
      
      public function BloodItem(param1:int)
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.BloodBack");
         addChild(this._bg);
         this._HPStrip = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.BloodFore");
         addChild(this._HPStrip);
         this._width = this._HPStrip.width;
         this._totalBlood = param1;
         this._bloodNum = param1;
         this._visibleRect = new Rectangle(0,0,this._HPStrip.width,this._HPStrip.height);
         this._HPStrip.scrollRect = this._visibleRect;
      }
      
      public function setProgress(param1:int, param2:int) : void
      {
         this._visibleRect.width = this._width * param1 / param2;
         this._HPStrip.scrollRect = this._visibleRect;
      }
      
      public function set bloodNum(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this._totalBlood)
         {
            param1 = this._totalBlood;
         }
         this._bloodNum = param1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         this._visibleRect.width = Math.floor(this._HPStrip.width * this._bloodNum / this._totalBlood);
         this._HPStrip.scrollRect = this._visibleRect;
      }
      
      public function dispose() : void
      {
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         removeChild(this._HPStrip);
         this._HPStrip.bitmapData.dispose();
         this._HPStrip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
