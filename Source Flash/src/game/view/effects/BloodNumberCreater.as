package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class BloodNumberCreater
   {
       
      
      private var greenData:Vector.<BitmapData>;
      
      private var redData:Vector.<BitmapData>;
      
      public function BloodNumberCreater()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.redData = new Vector.<BitmapData>();
         this.greenData = new Vector.<BitmapData>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.redData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUm" + _loc1_ + "Asset"));
            this.greenData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUma" + _loc1_ + "Asset"));
            _loc1_++;
         }
      }
      
      public function createGreenNum(param1:int) : Bitmap
      {
         return new Bitmap(this.greenData[param1]);
      }
      
      public function createRedNum(param1:int) : Bitmap
      {
         return new Bitmap(this.redData[param1]);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.redData[_loc1_].dispose();
            this.redData[_loc1_] = null;
            this.greenData[_loc1_].dispose();
            this.greenData[_loc1_] = null;
            _loc1_++;
         }
      }
   }
}
