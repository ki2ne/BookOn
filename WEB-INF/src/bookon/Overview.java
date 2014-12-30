package bookon;

import java.awt.BasicStroke;
import java.awt.Color;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.block.BlockBorder;
import org.jfree.chart.plot.PiePlot;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.ui.RectangleEdge;

public class Overview extends HttpServlet {

	@Override
	  protected void doGet(HttpServletRequest request, HttpServletResponse response)
	      throws ServletException, IOException {
	 
	    // コンテンツタイプ設定
	    response.setContentType("image/png");
	 
	    // 円グラフのデータ作成
	    DefaultPieDataset data = new DefaultPieDataset();
	    data.setValue("OS", 46);
	    data.setValue("プログラミング", 34);
	    data.setValue("ネット", 32);
	    data.setValue("アプリ", 23);
	    data.setValue("経理", 12);
	    data.setValue("資格", 5);
	    data.setValue("電気", 3);
	    data.setValue("その他", 3);
	 
	    // 日本語の文字化けを抑制
	    ChartFactory.setChartTheme(StandardChartTheme.createLegacyTheme());
	    
		// JFreeChartオブジェクト作成
	    JFreeChart chart = ChartFactory.createPieChart("", data, true, true, false);
	    
	    // 背景色を削除
	    chart.setBackgroundPaint(Color.WHITE);
	    // 凡例のアウトラインを削除
	    chart.getLegend().setFrame(BlockBorder.NONE);
	    // 凡例の位置を右に固定
	    chart.getLegend().setPosition(RectangleEdge.RIGHT);
	    
	    PiePlot plot = (PiePlot) chart.getPlot();
	    
	    plot.setSectionPaint("OS", new Color(0, 136, 204));
	    plot.setSectionPaint("プログラミング", new Color(248, 148, 6));
	    plot.setSectionPaint("ネット", new Color(81, 163, 81));
	    plot.setSectionPaint("アプリ", new Color(162, 0, 255));
	    plot.setSectionPaint("経理", new Color(242, 48, 84));
	    plot.setSectionPaint("資格", new Color(216, 0, 155));
	    plot.setSectionPaint("電気", new Color(255, 88, 13));
	    plot.setSectionPaint("その他", new Color(189, 54, 47));
	    
	    // アウトラインを削除
	    plot.setOutlineVisible(false);
	    // ラベルを削除
	    plot.setLabelGenerator(null);
	    // セクション間の境界線の削除
	    //plot.setBaseSectionOutlinePaint(new Color(0, 0, 0, 0));
	    // セクション間の境界線を設定
	    plot.setBaseSectionOutlinePaint(Color.WHITE);
	    plot.setBaseSectionOutlineStroke(new BasicStroke(3, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
	    // 影の削除
	    plot.setShadowPaint(null);
	 
	    // 円グラフ出力
	    ChartUtilities.writeChartAsPNG(response.getOutputStream(), chart, 400, 400);
	 
	    // アウトプットストリームをフラッシュ
	    response.getOutputStream().flush();
	  }
}
