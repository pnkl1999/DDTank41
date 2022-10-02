package game.view
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.LanguageMgr;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ExitHintView extends Frame
   {
       
      
      public function ExitHintView(param1:String, param2:String, param3:Boolean = true, param4:Function = null, param5:Function = null, param6:String = null, param7:String = null, param8:Number = 0)
      {
         super();
      }
      
      public static function show(param1:String, param2:String, param3:Boolean = true, param4:Function = null, param5:Function = null, param6:Boolean = true, param7:String = null, param8:String = null, param9:Number = 0, param10:Boolean = true) : Frame
      {
         var _loc12_:TextField = null;
         _loc12_ = null;
         var _loc11_:TextFormat = new TextFormat("Arial",12,16711680);
         _loc12_ = new TextField();
         _loc12_.defaultTextFormat = _loc11_;
         _loc12_.text = LanguageMgr.GetTranslation("tank.view.ExitHint.hint.text");
         _loc12_.autoSize = TextFieldAutoSize.LEFT;
         _loc12_.x = 48;
         _loc12_.y = 83;
         var _loc13_:Frame = new ExitHintView(param1,param2,param3,param4,param5,param7,param8,param9);
         LayerManager.Instance.addToLayer(_loc13_,LayerManager.GAME_DYNAMIC_LAYER);
         _loc13_.addChild(_loc12_);
         return _loc13_;
      }
   }
}
