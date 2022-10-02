package game.view.playerThumbnail
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import game.model.Living;
   import game.model.Player;
   import game.model.SimpleBoss;
   
   public class HeadFigure extends Sprite implements Disposeable
   {
       
      
      private var _head:Bitmap;
      
      private var _info:Player;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _living:Living;
      
      private var _isGray:Boolean = false;
      
      public function HeadFigure(param1:Number, param2:Number, param3:Object = null)
      {
         super();
         if(param3 is Player)
         {
            this._info = param3 as Player;
            if(this._info && this._info.character)
            {
               this._info.character.addEventListener(Event.COMPLETE,this.bitmapChange);
            }
         }
         else
         {
            this._living = param3 as Living;
            this._living.addEventListener(Event.COMPLETE,this.bitmapChange);
         }
         this._width = param1;
         this._height = param2;
         this.initFigure();
         this.width = param1;
         this.height = param2;
      }
      
      private function initFigure() : void
      {
         if(this._living)
         {
            this._head = new Bitmap(this._living.thumbnail.clone(),"auto",true);
            addChild(this._head);
         }
         else if(this._info && this._info.character)
         {
            this.drawHead(this._info.character.characterBitmapdata);
            addChild(this._head);
         }
      }
      
      private function bitmapChange(param1:Event) : void
      {
         if(!this._info || !this._info.character)
         {
            return;
         }
         this.drawHead(this._info.character.characterBitmapdata);
         if(this._isGray)
         {
            this.gray();
         }
      }
      
      private function drawHead(param1:BitmapData) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._head)
         {
            if(this._head.parent)
            {
               this._head.parent.removeChild(this._head);
            }
            this._head.bitmapData.dispose();
            this._head = null;
         }
         this._head = new Bitmap(new BitmapData(this._width,this._height,true,0),PixelSnapping.AUTO,true);
         var _loc2_:Rectangle = this.getHeadRect();
         var _loc3_:Matrix = new Matrix();
         _loc3_.identity();
         _loc3_.scale(this._width / _loc2_.width,this._height / _loc2_.height);
         _loc3_.translate(-_loc2_.x * (this._width / _loc2_.width),-_loc2_.y * (this._height / _loc2_.height));
         this._head.bitmapData.draw(param1,_loc3_);
         addChild(this._head);
      }
      
      private function getHeadRect() : Rectangle
      {
         if(this._info == null)
         {
            if(this._living is SimpleBoss)
            {
               return new Rectangle(0,0,300,300);
            }
            return new Rectangle(-2,-2,80,80);
         }
         if(this._info.playerInfo.getSuitsType() == 1)
         {
            return new Rectangle(21,12,167,165);
         }
         return new Rectangle(16,58,170,170);
      }
      
      public function gray() : void
      {
         if(this._head)
         {
            this._head.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         this._isGray = true;
      }
      
      public function dispose() : void
      {
         if(this._info)
         {
            if(this._info.character)
            {
               this._info.character.removeEventListener(Event.COMPLETE,this.bitmapChange);
            }
         }
         if(this._head)
         {
            if(this._head.parent)
            {
               this._head.parent.removeChild(this._head);
            }
            this._head.bitmapData.dispose();
            this._head = null;
         }
         this._living = null;
         this._head = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
