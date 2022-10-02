package com.pickgliss.loader
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   
   public class BitmapLoader extends DisplayLoader
   {
      
      private static const InvalidateBitmapDataID:int = 2015;
       
      
      private var _sourceBitmap:Bitmap;
      
      public function BitmapLoader(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      override public function get content() : *
      {
         if(this._sourceBitmap == null)
         {
            return null;
         }
         return this._sourceBitmap;
      }
      
      public function get bitmapData() : BitmapData
      {
         if(this._sourceBitmap)
         {
            return this._sourceBitmap.bitmapData;
         }
         return null;
      }
      
      override protected function __onContentLoadComplete(param1:Event) : void
      {
         this._sourceBitmap = _displayLoader.content as Bitmap;
         super.__onContentLoadComplete(param1);
      }
      
      override public function get type() : int
      {
         return BaseLoader.BITMAP_LOADER;
      }
   }
}
