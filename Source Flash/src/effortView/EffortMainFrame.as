package effortView
{
   import bagAndInfo.info.PlayerInfoEffortHonorView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import effortView.leftView.EffortTaskView;
   import effortView.rightView.EffortPullComboBox;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortMainFrame extends Frame implements Disposeable
   {
       
      
      private var _effortPannelView:EffortPannelView;
      
      private var _controller:EffortController;
      
      private var _effortTaskView:EffortTaskView;
      
      private var _bg:Scale9CornerImage;
      
      private var _titleBg:Bitmap;
      
      private var _border:Bitmap;
      
      private var _gray:ScaleBitmapImage;
      
      private var _grayII:ScaleBitmapImage;
      
      private var _effortPullComboBox:EffortPullComboBox;
      
      private var _playerInfoEffortHonorView:PlayerInfoEffortHonorView;
      
      private var _achievementPointText:FilterFrameText;
      
      private var _comboBoxBg:Bitmap;
      
      public function EffortMainFrame()
      {
         super();
         this.initContent();
         this.initEvent();
      }
      
      private function initContent() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Point = null;
         _loc2_ = null;
         var _loc3_:Point = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.bg0");
         addToContent(this._bg);
         this._border = ComponentFactory.Instance.creatBitmap("asset.Effort.bg_02");
         addToContent(this._border);
         this._gray = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.bg_01");
         addToContent(this._gray);
         this._grayII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.bg_02");
         addToContent(this._grayII);
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.Effort.titleBg_01");
         addToContent(this._titleBg);
         this._achievementPointText = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.AchievementPointText");
         if(EffortManager.Instance.isSelf)
         {
            this._achievementPointText.text = String(PlayerManager.Instance.Self.AchievementPoint);
            SocketManager.Instance.out.sendRequestUpdate();
         }
         else
         {
            this._achievementPointText.text = String(EffortManager.Instance.getTempAchievementPoint());
         }
         addToContent(this._achievementPointText);
         this._controller = new EffortController();
         this._controller.isSelf = EffortManager.Instance.isSelf;
         this._controller.currentViewType = 0;
         this._effortPannelView = new EffortPannelView(this._controller);
         addToContent(this._effortPannelView);
         this._effortPullComboBox = new EffortPullComboBox(this._controller);
         addToContent(this._effortPullComboBox);
         this._comboBoxBg = ComponentFactory.Instance.creatBitmap("asset.Effort.comboBoxBg");
         addToContent(this._comboBoxBg);
         if(EffortManager.Instance.isSelf)
         {
            this._effortPullComboBox.visible = false;
            this._playerInfoEffortHonorView = new PlayerInfoEffortHonorView();
            _loc2_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortMainFrame.EffortHonorViewPos");
            this._playerInfoEffortHonorView.x = _loc2_.x;
            this._playerInfoEffortHonorView.y = _loc2_.y;
            addToContent(this._playerInfoEffortHonorView);
         }
         else
         {
            this._effortPullComboBox.visible = false;
            this._comboBoxBg.visible = false;
         }
         if(EffortManager.Instance.isSelf)
         {
            this._effortTaskView = new EffortTaskView();
            _loc3_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortTaskView.EffortTaskViewPos");
            this._effortTaskView.x = _loc3_.x;
            this._effortTaskView.y = _loc3_.y;
            addToContent(this._effortTaskView);
         }
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortView.EffortViewPos");
         this.x = _loc1_.x;
         this.y = _loc1_.y;
      }
      
      private function initEvent() : void
      {
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(param1:Event) : void
      {
         if(this._controller.currentRightViewType == 0)
         {
            if(!EffortManager.Instance.isSelf)
            {
               this._comboBoxBg.visible = false;
            }
            if(this._effortPullComboBox)
            {
               this._effortPullComboBox.visible = false;
            }
            if(this._playerInfoEffortHonorView)
            {
               this._playerInfoEffortHonorView.visible = true;
            }
         }
         else
         {
            if(this._comboBoxBg)
            {
               this._comboBoxBg.visible = true;
            }
            if(this._effortPullComboBox)
            {
               this._effortPullComboBox.visible = true;
            }
            if(this._playerInfoEffortHonorView)
            {
               this._playerInfoEffortHonorView.visible = false;
            }
         }
      }
      
      override public function dispose() : void
      {
         this._controller.removeEventListener(Event.CHANGE,this.__rightChange);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         if(this._comboBoxBg)
         {
            ObjectUtils.disposeObject(this._comboBoxBg);
            this._comboBoxBg = null;
         }
         if(this._effortPannelView && this._effortPannelView.parent)
         {
            this._effortPannelView.parent.removeChild(this._effortPannelView);
            this._effortPannelView.dispose();
            this._effortPannelView = null;
         }
         if(this._effortTaskView && this._effortTaskView.parent)
         {
            this._effortTaskView.parent.removeChild(this._effortTaskView);
            this._effortTaskView.dispose();
            this._effortTaskView = null;
         }
         if(this._titleBg && this._titleBg.bitmapData)
         {
            this._titleBg.bitmapData.dispose();
            this._titleBg = null;
         }
         if(this._border && this._border.bitmapData)
         {
            this._border.bitmapData.dispose();
            this._border = null;
         }
         if(this._gray && this._gray.parent)
         {
            this._gray.parent.removeChild(this._gray);
            this._gray.dispose();
            this._gray = null;
         }
         if(this._grayII && this._grayII.parent)
         {
            this._grayII.parent.removeChild(this._grayII);
            this._grayII.dispose();
            this._grayII = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(this._effortPullComboBox && this._effortPullComboBox.parent)
         {
            this._effortPullComboBox.parent.removeChild(this._effortPullComboBox);
            this._effortPullComboBox.dispose();
            this._effortPullComboBox = null;
         }
         if(this._playerInfoEffortHonorView)
         {
            this._playerInfoEffortHonorView.dispose();
            this._playerInfoEffortHonorView = null;
         }
         super.dispose();
      }
   }
}
