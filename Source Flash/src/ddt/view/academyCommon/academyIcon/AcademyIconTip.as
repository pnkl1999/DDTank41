package ddt.view.academyCommon.academyIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class AcademyIconTip extends Sprite implements Disposeable, ITip
   {
      
      public static const MAX_HEIGHT:int = 70;
      
      public static const MIN_HEIGHT:int = 22;
       
      
      private var _tipData:PlayerInfo;
      
      private var _contentLabel:TextFormat;
      
      private var _bg:ScaleBitmapImage;
      
      private var _textFrameArray:Vector.<FilterFrameText>;
      
      public function AcademyIconTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.academyIconTipsBG");
         addChild(this._bg);
         this._textFrameArray = new Vector.<FilterFrameText>();
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxt");
         addChild(_loc1_);
         this._textFrameArray.push(_loc1_);
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxtII");
         addChild(_loc2_);
         this._textFrameArray.push(_loc2_);
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.contentTxtIII");
         addChild(_loc3_);
         this._textFrameArray.push(_loc3_);
         this._contentLabel = ComponentFactory.Instance.model.getSet("academyCommon.academyIcon.contentLabelTF");
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as PlayerInfo;
         if(this._tipData)
         {
            this.update();
         }
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function update() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = PlayerManager.Instance.Self.ID == this._tipData.ID;
         this._textFrameArray[0].visible = this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         if(this._tipData.apprenticeshipState == AcademyManager.MASTER_STATE || this._tipData.apprenticeshipState == AcademyManager.MASTER_FULL_STATE)
         {
            _loc2_ = 0;
            while(_loc2_ <= (this._tipData.getMasterOrApprentices().length >= 3 ? 2 : this._tipData.getMasterOrApprentices().length))
            {
               if(this._tipData.getMasterOrApprentices().list[_loc2_] && this._tipData.getMasterOrApprentices().list[_loc2_] != "")
               {
                  this._textFrameArray[_loc2_].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.master",this._tipData.getMasterOrApprentices().list[_loc2_]);
                  this._textFrameArray[_loc2_].setTextFormat(this._contentLabel,0,this._tipData.getMasterOrApprentices().list[_loc2_].length);
                  this._textFrameArray[_loc2_].visible = true;
               }
               else
               {
                  _loc3_ = 3 - this._tipData.getMasterOrApprentices().length;
                  this._textFrameArray[_loc2_].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.masterExplanation",_loc3_);
                  this._textFrameArray[_loc2_].visible = true;
               }
               _loc2_++;
            }
         }
         else if(this._tipData.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
         {
            if(this._tipData.getMasterOrApprentices().list[0] && this._tipData.getMasterOrApprentices().list[0] != "")
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.Apprentice",this._tipData.getMasterOrApprentices().list[0]);
               this._textFrameArray[0].setTextFormat(this._contentLabel,0,this._tipData.getMasterOrApprentices().list[0].length);
               this._textFrameArray[0].visible = true;
            }
            else if(!_loc1_)
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeExplanation");
               this._textFrameArray[0].visible = true;
            }
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         else if(this._tipData.ID == PlayerManager.Instance.Self.ID && this._tipData.apprenticeshipState == AcademyManager.NONE_STATE)
         {
            this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeNull");
            this._textFrameArray[0].visible = true;
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         else
         {
            if(this._tipData.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
            {
               if(!_loc1_)
               {
                  _loc4_ = 3 - this._tipData.getMasterOrApprentices().length;
                  this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.masterExplanation",_loc4_);
                  this._textFrameArray[0].visible = true;
               }
            }
            else if(!_loc1_)
            {
               this._textFrameArray[0].text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.ApprenticeExplanation");
               this._textFrameArray[0].visible = true;
            }
            this._textFrameArray[1].visible = this._textFrameArray[2].visible = false;
         }
         this.updateBgSize();
      }
      
      private function updateBgSize() : void
      {
         var _loc1_:Boolean = PlayerManager.Instance.Self.ID == this._tipData.ID;
         this._bg.width = this.getMaxWidth();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._textFrameArray.length)
         {
            if(this._textFrameArray[_loc3_].visible)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         this._bg.height = _loc2_ * MIN_HEIGHT;
      }
      
      private function getApprenticesNum() : String
      {
         var _loc1_:int = 3 - this._tipData.getMasterOrApprentices().length;
         switch(_loc1_)
         {
            case 1:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.1");
            case 2:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.2");
            case 3:
               return LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.AcademyIconTip.3");
            default:
               return "";
         }
      }
      
      private function getMaxWidth() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._textFrameArray.length)
         {
            if(this._textFrameArray[_loc2_].visible && this._textFrameArray[_loc2_].width > _loc1_)
            {
               _loc1_ = this._textFrameArray[_loc2_].width;
            }
            _loc2_++;
         }
         return _loc1_ + 10;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this._textFrameArray)
         {
            _loc1_ = 0;
            while(_loc1_ < this._textFrameArray.length)
            {
               this._textFrameArray[_loc1_].dispose();
               this._textFrameArray[_loc1_] = null;
               _loc1_++;
            }
         }
         if(this._bg)
         {
            this._bg.dispose();
            this._bg = null;
         }
         this._contentLabel = null;
      }
   }
}
