package ddt.utils
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HelpFrameUtils
   {
      
      private static var _instance:HelpFrameUtils;
       
      
      public function HelpFrameUtils()
      {
         super();
      }
      
      public static function get Instance() : HelpFrameUtils
      {
         if(_instance == null)
         {
            _instance = new HelpFrameUtils();
         }
         return _instance;
      }
      
      public function simpleHelpButton(param1:Sprite, param2:String, param3:Object = null, param4:String = "", param5:Object = null, param6:Number = 0, param7:Number = 0, param8:Boolean = true, param9:Boolean = true, param10:Object = null, param11:int = 2) : *
      {
         var _loc14_:* = undefined;
         var _loc12_:* = null;
         var _loc13_:* = ComponentFactory.Instance.creat(param2);
         if(param3)
         {
            if(param3 is Point)
            {
               _loc13_.x = param3.x;
               _loc13_.y = param3.y;
            }
            else if(param3 is String)
            {
               PositionUtils.setPos(_loc13_,param3);
            }
            else
            {
               for(_loc14_ in param3)
               {
                  _loc13_[_loc14_] = param3[_loc14_];
               }
            }
         }
         if(param5)
         {
            _loc12_ = {
               "titleText":param4,
               "content":param5,
               "width":param6,
               "height":param7,
               "isShowContentBg":param8,
               "isShow":param9,
               "alertInfo":param10,
               "showLayerType":param11
            };
            _loc13_.tipData = {"helpFrameData":_loc12_};
            _loc13_.addEventListener("click",this.__helpButtonClick);
            _loc13_.addEventListener("dispose",this.__helpButtonDispose);
         }
         if(param1)
         {
            if(param1 is Frame)
            {
               Frame(param1).addToContent(_loc13_);
            }
            else
            {
               param1.addChild(_loc13_);
            }
         }
         return _loc13_;
      }
      
      private function __helpButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         if(param1.currentTarget.hasOwnProperty("tipData") && param1.currentTarget.tipData && param1.currentTarget.tipData.helpFrameData)
         {
            _loc2_ = param1.currentTarget.tipData.helpFrameData;
            this.simpleHelpFrame(_loc2_.titleText,_loc2_.content,_loc2_.width,_loc2_.height,_loc2_.isShowContentBg,_loc2_.isShow,_loc2_.alertInfo,_loc2_.showLayerType);
         }
      }
      
      private function __helpButtonDispose(param1:ComponentEvent) : void
      {
         param1.currentTarget.removeEventListener("click",this.__helpButtonClick);
         param1.currentTarget.removeEventListener("dispose",this.__helpButtonDispose);
      }
      
      public function simpleHelpFrame(param1:String, param2:Object, param3:Number, param4:Number, param5:Boolean = true, param6:Boolean = true, param7:Object = null, param8:int = 3) : BaseAlerFrame
      {
         var _loc12_:AlertInfo = null;
         var _loc13_:BaseAlerFrame = null;
         var _loc14_:* = undefined;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         (_loc12_ = new AlertInfo()).sound = "008";
         _loc12_.mutiline = true;
         _loc12_.buttonGape = 15;
         _loc12_.autoDispose = true;
         _loc12_.showCancel = false;
         _loc12_.moveEnable = true;
         _loc12_.escEnable = true;
         _loc12_.submitLabel = LanguageMgr.GetTranslation("ok");
         if(param7)
         {
            if(param7 is AlertInfo)
            {
               ObjectUtils.copyProperties(_loc12_,param7);
            }
            else
            {
               for(_loc14_ in param7)
               {
                  _loc12_[_loc14_] = param7[_loc14_];
               }
            }
         }
         (_loc13_ = ComponentFactory.Instance.creatComponentByStylename("BaseFrame")).info = _loc12_;
         _loc13_.moveInnerRectString = "0,30,0,30,1";
         _loc13_.width = param3;
         _loc13_.height = param4;
         _loc13_.titleText = param1;
         _loc13_.addEventListener("response",this.__helpFrameRespose);
         if(param5)
         {
            (_loc9_ = ComponentFactory.Instance.creatComponentByStylename("core.Scale9CornerImage.scale9CornerImagereleaseContentTextBG")).width = _loc13_.width - 30;
            _loc9_.height = _loc13_.height - 98;
            _loc9_.x = (_loc13_.width - _loc9_.width) / 2;
            _loc9_.y = 40;
            _loc13_.addToContent(_loc9_);
         }
         if(param2 is DisplayObject)
         {
            _loc13_.addToContent(param2 as DisplayObject);
         }
         else if(param2 is Array)
         {
            _loc10_ = 0;
            while(_loc10_ < param2.length)
            {
               if((_loc11_ = param2[_loc10_]) is DisplayObject)
               {
                  _loc13_.addToContent(_loc11_ as DisplayObject);
               }
               else
               {
                  _loc13_.addToContent(ComponentFactory.Instance.creat(_loc11_ as String));
               }
               _loc10_++;
            }
         }
         else
         {
            _loc13_.addToContent(ComponentFactory.Instance.creat(param2 as String));
         }
         if(param6)
         {
            LayerManager.Instance.addToLayer(_loc13_,param8,true,2);
         }
         return _loc13_;
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            param1.currentTarget.removeEventListener("response",this.__helpFrameRespose);
            param1.currentTarget.dispose();
         }
      }
   }
}
