package ddt.view.academyCommon.academyIcon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class AcademyIcon extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _icon:ScaleFrameImage;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _myColorMatrix_filter:ColorMatrixFilter;
      
      public function AcademyIcon()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._icon = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyIcon.academyIconBG");
         this._icon.setFrame(1);
         addChild(this._icon);
         ShowTipManager.Instance.addTip(this);
         this._myColorMatrix_filter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
      }
      
      private function updateIcon() : void
      {
         if(this._tipData.apprenticeshipState == AcademyManager.NONE_STATE)
         {
            this.filters = [this._myColorMatrix_filter];
         }
         else
         {
            this.filters = null;
         }
         if(this._tipData.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
         {
            this._icon.setFrame(2);
         }
         else
         {
            this._icon.setFrame(1);
         }
         if(this._tipData.ID == PlayerManager.Instance.Self.ID)
         {
            buttonMode = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            buttonMode = false;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         if(this._tipData.apprenticeshipState == AcademyManager.NONE_STATE && (this._tipData.Grade < AcademyManager.TARGET_PLAYER_MIN_LEVEL || AcademyManager.Instance.isOpenSpace(this._tipData as PlayerInfo)))
         {
            this._icon.visible = false;
         }
         else
         {
            this._icon.visible = true;
         }
         if(AcademyManager.Instance.isFighting())
         {
            buttonMode = false;
         }
         else
         {
            buttonMode = true;
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         if(AcademyManager.Instance.isFighting())
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._tipData.apprenticeshipState == AcademyManager.NONE_STATE)
         {
            AcademyFrameManager.Instance.showAcademyPreviewFrame();
         }
         else
         {
            AcademyManager.Instance.myAcademy();
         }
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.CLICK,this.__onClick);
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         this._myColorMatrix_filter = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
         this.updateIcon();
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
