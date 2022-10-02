package littleGame.view
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.ddt_internal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import littleGame.LittleGameManager;
   
   use namespace ddt_internal;
   
   public class PriceShape extends Bitmap implements Disposeable
   {
       
      
      public function PriceShape(price:int)
      {
         super(null,"auto",true);
         this.drawPrice(price);
      }
      
      private function drawPrice(price:int) : void
      {
         var back:BitmapData = LittleGameManager.Instance.Current.priceBack;
         var left:int = back.width;
         var src:BitmapData = LittleGameManager.Instance.Current.priceNum;
         var priceStr:String = price.toString();
         var w:int = src.width / 10;
         var h:int = src.height;
         var bitmap:BitmapData = new BitmapData(left + priceStr.length * w,back.height,true,0);
         bitmap.copyPixels(back,back.rect,new Point(0,0));
         var rect:Rectangle = new Rectangle(0,0,w,h);
         var len:int = priceStr.length;
         for(var i:int = 0; i < len; i++)
         {
            rect.x = int(priceStr.substr(i,1)) * w;
            bitmap.copyPixels(src,rect,new Point(left + w * i,0));
         }
         if(bitmapData)
         {
            bitmapData.dispose();
         }
         bitmapData = bitmap;
      }
      
      public function dispose() : void
      {
         if(bitmapData)
         {
            bitmapData.dispose();
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
