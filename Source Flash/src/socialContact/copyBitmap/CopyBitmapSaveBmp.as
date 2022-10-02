package socialContact.copyBitmap
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class CopyBitmapSaveBmp
   {
       
      
      private var _jpgEncder:JPGEncoder;
      
      private var _bitmapData:BitmapData;
      
      public function CopyBitmapSaveBmp()
      {
         this._jpgEncder = new JPGEncoder();
         super();
      }
      
      public function copyBmp(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:BitmapData = new BitmapData(StageReferance.stage.stageWidth,StageReferance.stage.stageHeight);
         _loc5_.draw(StageReferance.stage);
         this._bitmapData = new BitmapData(Math.abs(param3 - param1),Math.abs(param4 - param2));
         var _loc6_:int = param1 < param3 ? int(int(param1)) : int(int(param3));
         var _loc7_:int = param2 < param4 ? int(int(param2)) : int(int(param4));
         this._bitmapData.copyPixels(_loc5_,new Rectangle(_loc6_,_loc7_,Math.abs(param3 - param1),Math.abs(param4 - param2)),new Point(0,0));
         _loc5_.dispose();
         _loc5_ = null;
      }
      
      public function get bitmapData() : ByteArray
      {
         return this._jpgEncder.encode(this._bitmapData);
      }
   }
}
