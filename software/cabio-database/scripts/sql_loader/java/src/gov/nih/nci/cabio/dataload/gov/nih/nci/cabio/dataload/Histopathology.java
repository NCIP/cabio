/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.dataload;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

/**
 * This class generates context.sql and gene_histo.txt that are required for
 * histopathology data loading
 * 
 * @author Liqun Qi, modified by Sue Pan
 * 
 */
public class Histopathology {

	private Connection con = null;
	private String outputDirectory;
	private String outFileName1;
	private String outFileName2;
	private int lastContextCode;

	public Histopathology(Connection con, String outputDirectory,
			String outFileName1, String outFileName2) {
		this.con = con;
		this.outputDirectory = outputDirectory;
		this.outFileName1 = outFileName1;
		this.outFileName2 = outFileName2;
	}

	/** get existing contexts from database */
	public HashMap<String, String> getContexts() throws Exception {

		HashMap<String, String> result = new HashMap<String, String>();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "select context_code, tissue_code, histology_code from context order by context_code";
			stmt = con.prepareStatement(sql);
			stmt.executeQuery();
			rs = stmt.executeQuery();
			while (rs.next()) {
				int context_code = rs.getInt(1);
				int tissue_code = rs.getInt(2);
				int histology_code = rs.getInt(3);
				result.put(
						Integer.toString(tissue_code) + "|"
								+ Integer.toString(histology_code),
						Integer.toString(context_code));
				lastContextCode = context_code;
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (stmt != null)
				stmt.close();
			if (rs != null)
				rs.close();
		}

		return result;
	}

	public HashMap<String, String> getHistos() throws Exception {

		HashMap<String, String> result = new HashMap<String, String>();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "select histology_code, histology_name from histology_code";
			stmt = con.prepareStatement(sql);
			stmt.executeQuery();
			rs = stmt.executeQuery();
			while (rs.next()) {
				int histology_code = rs.getInt(1);
				String histology_name = rs.getString(2);
				result.put(histology_name.trim().toLowerCase(),
						Integer.toString(histology_code));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			if (stmt != null)
				stmt.close();
			if (rs != null)
				rs.close();
		}
		return result;
	}

	public HashMap<String, String> getTissues() throws Exception {

		HashMap<String, String> result = new HashMap<String, String>();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "select tissue_code, tissue_name from tissue_code";
			stmt = con.prepareStatement(sql);
			stmt.executeQuery();
			rs = stmt.executeQuery();
			while (rs.next()) {
				int tissue_code = rs.getInt(1);
				String tissue_name = rs.getString(2);
				result.put(tissue_name.trim().toLowerCase(),
						Integer.toString(tissue_code));
			}

		} catch (Exception e) {
			throw e;
		} finally {
			if (stmt != null)
				stmt.close();

			if (rs != null)
				rs.close();
		}

		return result;
	}

	/* this method depends on table zstg_gene_kw being there already */
	public void process() throws Exception {
		File outFile1 = new File(outputDirectory, outFileName1);
		File outFile2 = new File(outputDirectory, outFileName2);
		PrintWriter pw = null;
		PrintWriter pw2 = null;

		HashMap<String, String> context = getContexts();
		HashMap<String, String> histo = getHistos();
		HashMap<String, String> tissue = getTissues();

		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			pw = new PrintWriter(outFile1);
			pw2 = new PrintWriter(outFile2);
			String sql = "select gene_id, keyword from zstg_gene_kw";
			stmt = con.prepareStatement(sql);
			stmt.executeQuery();
			rs = stmt.executeQuery();
			while (rs.next()) {
				int gene_id = rs.getInt(1);
				String kw = rs.getString(2);

				String[] kw_array = kw.split(",");

				String h_code = null;
				String t_code = null;
				for (int i = 0; i < kw_array.length; i++) {

					String key = kw_array[i].trim().toLowerCase();
					if (h_code == null)
						h_code = histo.get(key);
					if (t_code == null)
						t_code = tissue.get(key);
				}

				String c_code = null;
				int startId = lastContextCode + 1;
				if (h_code != null && t_code != null) {
					c_code = context.get(t_code + "|" + h_code);
					if (c_code == null) {
						c_code = Integer.toString(startId);
						startId++;
						context.put(t_code + "|" + h_code, c_code);
						pw.println("INSERT INTO context(CONTEXT_CODE, histology_code, tissue_code) VALUES("
								+ c_code + "," + h_code + "," + t_code + ");");
						pw.flush();
					}
				}

				if (c_code != null) {
					String line = Integer.toString(gene_id) + "|" + c_code;
					pw2.println(line);
				}

			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (stmt != null)
				stmt.close();

			if (rs != null)
				rs.close();
		}

	}

	public static void main(String[] args) {
		try {
			/*
			 * outDir=/cabio/cabiodb/cabio_data/cgap; outFile1=context.sql;
			 * outFile2=gene_hist.txt
			 */
			String dbURL = args[0];
			String dbUser = args[1];
			String dbPass = args[2];
			Connection conn = DataConnection.instance(dbURL, dbUser, dbPass);
			String outDir = args[3];
			String outFile1 = args[4];
			String outFile2 = args[5];
			Histopathology his = new Histopathology(conn, outDir, outFile1,
					outFile2);
			his.process();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
