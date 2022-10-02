package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.events.Event;
   import labyrinth.LabyrinthManager;
   
   public class RankingListFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _list:ListPanel;
      
      public function RankingListFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.labyrinth.RankingListFrame.title"));
         info = _loc1_;
         this._bg = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.RankingListFrame.BG");
         addToContent(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.RankingListFrame.List");
         addToContent(this._list);
         this.initEvent();
         var _loc2_:Array = LabyrinthManager.Instance.model.rankingList;
         this._list.vectorListModel.appendAll(_loc2_);
         LabyrinthManager.Instance.loadRankingList();
      }
      
      private function initEvent() : void
      {
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.RANKING_LOAD_COMPLETE,this.__updateList);
      }
      
      protected function __updateList(param1:Event) : void
      {
         var _loc2_:Array = LabyrinthManager.Instance.model.rankingList;
         this._list.vectorListModel.appendAll(_loc2_);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.RANKING_LOAD_COMPLETE,this.__updateList);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
      }
   }
}
