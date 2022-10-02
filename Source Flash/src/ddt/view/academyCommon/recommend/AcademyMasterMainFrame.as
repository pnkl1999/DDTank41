package ddt.view.academyCommon.recommend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import flash.events.MouseEvent;
   
   public class AcademyMasterMainFrame extends AcademyApprenticeMainFrame implements Disposeable
   {
       
      
      public function AcademyMasterMainFrame()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.bottomGap = 11;
         info = _alertInfo;
         info.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyMasterMainFrame.title");
         _tree9CornerImage = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree");
         addToContent(_tree9CornerImage);
         _recommendTitle = ComponentFactory.Instance.creatBitmap("asset.academy.recommendTitleAssetII");
         addToContent(_recommendTitle);
         _titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.titleBtn");
         addToContent(_titleBtn);
         _playerContainer = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.playerContainer");
         addToContent(_playerContainer);
         _checkBoxBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtn");
         _checkBoxBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtnInfo");
         if(!SharedManager.Instance.isRecommend)
         {
            addToContent(_checkBoxBtn);
         }
      }
      
      override protected function initPlayerContainer() : void
      {
         var _loc2_:RecommendMasterPlayerCellView = null;
         _items = [];
         var _loc1_:int = 0;
         while(_loc1_ < MAX_ITEM)
         {
            _loc2_ = new RecommendMasterPlayerCellView();
            _loc2_.addEventListener(MouseEvent.CLICK,__itemClick);
            _playerContainer.addChild(_loc2_);
            _items.push(_loc2_);
            _loc1_++;
         }
         _players = AcademyManager.Instance.recommendPlayers;
         updateItem();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
