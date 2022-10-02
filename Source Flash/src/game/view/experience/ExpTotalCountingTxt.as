package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class ExpTotalCountingTxt extends ExpCountingTxt
   {
      
      public static const RED:uint = 16711680;
      
      public static const GREEN:uint = 65280;
       
      
      private var _bg:Bitmap;
      
      private var _color:uint;
      
      public function ExpTotalCountingTxt(param1:String, param2:String, param3:uint)
      {
         this._color = param3;
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         super.init();
         if(this._color == RED)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.TotalTxtRedBg");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.TotalTxtGreenBg");
         }
         addChildAt(this._bg,0);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         super.dispose();
      }
   }
}
