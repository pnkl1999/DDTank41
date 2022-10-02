package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.view.common.PreviewFrame;
   import flash.display.Bitmap;
   
   public class PreviewFrameManager
   {
      
      public static const DEFULT_FRAME_STYLE:String = "view.common.PreviewFrame";
      
      public static const DEFULT_SCROLL_STYLE:String = "view.common.PreviewFrame.PreviewScroll";
      
      public static const DEFULT_BUILD_FRAME_STYLE:String = "trainer.hall.buildPreviewFrame";
      
      public static const DEFULT_BUILD_SCROLL_STYLE:String = "view.common.masterAcademyPreviewFrame.PreviewScroll";
      
      private static var _instance:PreviewFrameManager;
       
      
      public function PreviewFrameManager()
      {
         super();
      }
      
      public static function get Instance() : PreviewFrameManager
      {
         if(_instance == null)
         {
            _instance = new PreviewFrameManager();
         }
         return _instance;
      }
      
      public function createsPreviewFrame(param1:String, param2:String, param3:String = "", param4:String = "", param5:Function = null, param6:Boolean = true) : void
      {
         var _loc7_:PreviewFrame = null;
         if(param3 == "")
         {
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename(DEFULT_FRAME_STYLE);
         }
         else
         {
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename(param3);
         }
         if(param4 == "")
         {
            _loc7_.setStyle(param1,param2,DEFULT_SCROLL_STYLE,param5,param6);
         }
         else
         {
            _loc7_.setStyle(param1,param2,param4,param5,param6);
         }
         _loc7_.show();
      }
      
      public function createBuildPreviewFrame(param1:String, param2:Bitmap) : void
      {
         var _loc3_:PreviewFrame = null;
         _loc3_ = ComponentFactory.Instance.creatComponentByStylename(DEFULT_BUILD_FRAME_STYLE);
         _loc3_.setStyle(param1,"",DEFULT_BUILD_SCROLL_STYLE,null,true,param2);
         _loc3_.show();
      }
   }
}
