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
   
   public class ScoreShape extends Bitmap implements Disposeable
   {
      
      ddt_internal static const size:int = 22;
       
      
      private var _style:int;
      
      public function ScoreShape(style:int = 0)
      {
         this._style = style;
         super(null,"auto",true);
      }
      
      public function setScore(score:int) : void
      {
         var src:BitmapData = null;
         var w:int = 0;
         var h:int = 0;
         var scoreStr:String = score.toString();
         if(this._style == 1)
         {
            src = LittleGameManager.Instance.Current.bigNum;
         }
         else
         {
            src = LittleGameManager.Instance.Current.normalNum;
         }
         w = src.width / 11;
         h = src.height;
         var bitmap:BitmapData = new BitmapData((scoreStr.length + 1) * w,h,true,0);
         var rect:Rectangle = new Rectangle(src.width - w,0,w,h);
         bitmap.copyPixels(src,rect,new Point(0,0));
         var len:int = scoreStr.length;
         for(var i:int = 0; i < len; i++)
         {
            rect.x = int(scoreStr.substr(i,1)) * w;
            bitmap.copyPixels(src,rect,new Point(w * (i + 1),0));
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
