package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SceneCharacterBase extends Sprite
   {
       
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _sceneCharacterActionItem:SceneCharacterActionItem;
      
      private var _frameIndex:int;
      
      public function SceneCharacterBase(param1:Vector.<Bitmap>)
      {
         this._frameIndex = Math.random() * 7;
         super();
         this._frameBitmap = param1;
         this.initialize();
      }
      
      private function initialize() : void
      {
      }
      
      public function update() : void
      {
         if(this._frameIndex < this._sceneCharacterActionItem.frames.length)
         {
            this.loadFrame(this._sceneCharacterActionItem.frames[this._frameIndex++]);
         }
         else if(this._sceneCharacterActionItem.repeat)
         {
            this._frameIndex = 0;
         }
      }
      
      private function loadFrame(param1:int) : void
      {
         if(param1 >= this._frameBitmap.length)
         {
            param1 = this._frameBitmap.length - 1;
         }
         if(this._frameBitmap && this._frameBitmap[param1])
         {
            if(this.numChildren > 0 && this.getChildAt(0))
            {
               removeChildAt(0);
            }
            addChild(this._frameBitmap[param1]);
         }
      }
      
      public function set sceneCharacterActionItem(param1:SceneCharacterActionItem) : void
      {
         this._sceneCharacterActionItem = param1;
         this._frameIndex = 0;
      }
      
      public function get sceneCharacterActionItem() : SceneCharacterActionItem
      {
         return this._sceneCharacterActionItem;
      }
      
      public function dispose() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         while(this._frameBitmap && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
         if(this._sceneCharacterActionItem)
         {
            this._sceneCharacterActionItem.dispose();
         }
         this._sceneCharacterActionItem = null;
      }
   }
}
