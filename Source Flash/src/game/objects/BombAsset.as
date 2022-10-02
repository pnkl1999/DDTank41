package game.objects
{
   import flash.display.Bitmap;
   
   public class BombAsset
   {
       
      
      public var crater:Bitmap;
      
      public var craterBrink:Bitmap;
      
      public function BombAsset()
      {
         super();
      }
      
      public function dispose() : void
      {
         if(this.crater && this.crater.bitmapData)
         {
            this.crater.bitmapData.dispose();
            this.crater = null;
         }
         if(this.craterBrink && this.craterBrink.bitmapData)
         {
            this.craterBrink.bitmapData.dispose();
            this.craterBrink = null;
         }
      }
   }
}
