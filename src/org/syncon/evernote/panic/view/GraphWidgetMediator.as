package  org.syncon.evernote.panic.view
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.charts.series.LineSeries;
	import mx.collections.ArrayCollection;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import org.robotlegs.mvcs.Mediator;
	import org.syncon.evernote.basic.model.CustomEvent;
	import org.syncon.evernote.panic.controller.WidgetEvent;
	import org.syncon.evernote.panic.model.PanicModel;
	import org.syncon.evernote.panic.model.PanicModelEvent;
	import org.syncon.evernote.panic.view.GraphWidget;
	import org.syncon.evernote.panic.vo.WidgetVO;
	
	import spark.filters.DropShadowFilter;
 
	public class GraphWidgetMediator extends WidgetMediatorBase
	{
		[Inject] public function set ui  ( i : GraphWidget) : void 
		{	this.widgetUI = i  }
		public function get ui () : GraphWidget
		{ return this.widgetUI as GraphWidget;  }
				
		public function GraphWidgetMediator()
		{
		} 
		
		override public function onRegister():void
		{
			super.onRegister();
			this.editPopupName = 'GraphWidgetEditorPopup';
		}
 
		
		override public function onSkinChanged(e:PanicModelEvent): void
		{
			this.ui.fontColor = this.model.color; 
		}		
		
		override public function automateWidget( settings : WidgetVO )  : void
		{
			this.ui.fillC = uint( settings.data.fillColor ) 
			this.source( settings.data.labelTop, this.ui, 'textTop', null )
			this.source( settings.data.labelBottom, this.ui, 'textBottom', null  )
			//if ( useSettings.data.test == null ) useSettings.data.test = {};
			this.source( settings.source, this, 'value', null   , settings.test.source )
			this.source( settings.data.max, this.ui, 'maximum', null  ); //this.ui.maximum;
			this.source( settings.data.fillColor, this.ui, 'fillC', null  ); 
			this.source( settings.background, this, 'updateBgText', null , settings.test.background )
				
			this.ui.chart.toolTip = settings.description;
			
		}
		
		public function set value ( s : String )  : void
		{
			if ( s.indexOf('{"pie":' ) != -1 )
			{
				this.loadPie( s )
					return; 
			}
			if ( s.indexOf('{"line":' ) != -1 )
			{
				this.loadLine( s ) 
					return;
			}
			this.ui.currentState = ''; 
			this.ui.value = s; 
		}
		private var oldPieString : String = ''; 
		public function loadPie( e :  String ) : void
		{
	 	
			if ( e == oldPieString ) 
			{
				this.ui.currentState = 'pieChart'; 
					return; 
			}
			this.oldPieString = e; 
			var s : Object = JSON.decode( e.toString() )
			var colors : Array = s.pie
				var fills : Array = []
				var prod : Array = []; 
			for each ( var j : Object in colors ) 
			{
				var section :  Object = {}
				section.Expense = j.name
				section.Amount = j.value; 
				prod.push( section ) 
				if ( j.color.toString().charAt(0) == '#' ) 
					var color:uint = uint("0x" + j.color.toString().substr(1));

					var c :  SolidColor = new SolidColor( color, 1 )  
					fills.push( c ) 

			}
			this.ui.currentState = 'pieChart'; 
			this.ui.myChart3.dataProvider = prod ; 
			this.ui.pieSeries.setStyle( 'fills', fills )
			/*this.ui.myChart3.dataProvider = new ArrayCollection([
				{Expense:"Taxes", Amount:2000},
				{Expense:"Rent", Amount:1000},
				{Expense:"Bills", Amount:100},
				{Expense:"Car", Amount:450},
				{Expense:"Gas", Amount:100},
				{Expense:"Food", Amount:200} ] )*/
			this.ui.currentState = 'pieChart'; 
		}
		
		private var oldLineString : String = ''; 
		public function loadLine( e :  String ) : void
		{
			if ( e == oldLineString ) 
			{
				this.ui.currentState = 'lineChart'; 
				return; 
			}
			this.oldLineString = e; 
			var filters : Array = []; 
		/*	*/
			var s : Object = JSON.decode( e.toString() )
			var colors : Array = s.pie
			var prod : Array = []; 
			for each ( var j : Object in s.line.series ) 
			{
		 
				trace( 'color input:  ' +  j.color.toString() );
				if ( j.color.toString().charAt(0) == '#' ) 
					var color:uint = uint("0x" + j.color.toString().substr(1));
				
				var c :    SolidColorStroke = new SolidColorStroke( color, 5 )  
				var ee : LineSeries = new LineSeries()
				ee.yField = j.name; 
				ee.displayName = j.name
				ee.setStyle(  'lineStroke' , c ) 
				ee.setStyle( 'form', 'segment' )
				ee.setStyle( 'form', 'curve' )
				prod.push( ee ) 
				var filter : DropShadowFilter = new DropShadowFilter( 2, 135, c.color, 0.3,  2, 3 ); //
				//filter = new DropShadowFilter( 4, 135, c.color, 0.5,  2, 3 ); //
				trace( 'color input:  ' +  filter.color );
				filters.push( filter ) 
				ee.filters = [filter]
			}
	 
			if ( this.ui.myChart4 == null ) this.ui.currentState = 'lineChart'; 
			this.ui.myChart4.series = prod; 
			this.ui.myChart4.dataProvider = s.line.data ;
			this.ui.myChart4.seriesFilters= [];
			
			/**/
			this.ui.currentState = 'lineChart'; 
		}
				
		
		private var oldBgTextString : String = ''; 
		public function set updateBgText(a : String ) : void
		{
			if ( a == this.oldBgTextString   ) 
				return
			this.oldBgTextString = a; 
			var ee :  HtmlConvertor = new HtmlConvertor()
			this.ui.txtBg.textFlow = ee.convert2( a, this.model.color, 15 ) 
			return  ; 
		}		
 
	}
}