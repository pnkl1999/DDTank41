package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PlayerPortraitView extends Sprite implements Disposeable
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
       
      
      private var _character:ShowCharacter;
      
      private var _figure:Bitmap;
      
      private var _iconBg:Bitmap;
      
      private var _directrion:String;
      
      private var _info:PlayerInfo;
      
      public function PlayerPortraitView(param1:String = "left")
      {
         super();
         this._directrion = param1;
         this._iconBg = ComponentFactory.Instance.creatBitmap("asset.IM.iconBg");
         addChild(this._iconBg);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this.showFigure(param1);
      }
      
      public function set isShowFrame(param1:Boolean) : void
      {
         if(param1)
         {
            addChildAt(this._iconBg,0);
         }
         else if(contains(this._iconBg))
         {
            removeChild(this._iconBg);
         }
      }
      
      private function showFigure(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(this._character)
         {
            this._character.removeEventListener(Event.COMPLETE,this.__characterComplete);
            this._character.dispose();
            this._character = null;
         }
         if(this._figure && this._figure.parent && this._figure.bitmapData)
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         this._character = CharactoryFactory.createCharacter(param1) as ShowCharacter;
         this._character.addEventListener(Event.COMPLETE,this.__characterComplete);
         this._character.showGun = false;
         this._character.setShowLight(false,null);
         this._character.stopAnimation();
         this._character.show(true,1);
         this._character.buttonMode = this._character.mouseEnabled = this._character.mouseEnabled = false;
      }
      
      private function __characterComplete(param1:Event) : void
      {
         if(this._figure && this._figure.parent && this._figure.bitmapData)
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         this._figure = new Bitmap(new BitmapData(200,150));
         this._figure.bitmapData.copyPixels(this._character.characterBitmapdata,new Rectangle(0,60,200,150),new Point(0,0));
         this._figure.scaleX = 0.45 * (this._directrion == LEFT ? 1 : -1);
         this._figure.scaleY = 0.45;
         this._figure.x = this._directrion == LEFT ? Number(Number(0)) : Number(Number(82));
         this._figure.y = 2;
         addChild(this._figure);
      }
      
      public function dispose() : void
      {
         this._info = null;
         if(this._character)
         {
            this._character.removeEventListener(Event.COMPLETE,this.__characterComplete);
            this._character.dispose();
            this._character = null;
         }
         if(this._figure && this._figure.parent && this._figure.bitmapData)
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         if(this._iconBg && this._iconBg.parent && this._iconBg.bitmapData)
         {
            this._iconBg.parent.removeChild(this._iconBg);
            this._iconBg.bitmapData.dispose();
            this._iconBg = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
