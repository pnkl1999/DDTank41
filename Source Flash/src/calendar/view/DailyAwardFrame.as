package calendar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class DailyAwardFrame extends BaseAlerFrame
   {
       
      
      private var _goodBg:Scale9CornerImage;
      
      private var _good:Bitmap;
      
      public function DailyAwardFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._goodBg = ComponentFactory.Instance.creatComponentByStylename("Calendar.DailyFrameGoodsBg");
         this._good = ComponentFactory.Instance.creatBitmap("Calendar.DailyGoodInfo");
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.calendar.DailyAwardTitle"));
         _loc1_.moveEnable = false;
         info = _loc1_;
         addToContent(this._goodBg);
         addToContent(this._good);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._goodBg);
         this._goodBg = null;
         ObjectUtils.disposeObject(this._good);
         this._good = null;
         super.dispose();
      }
   }
}
