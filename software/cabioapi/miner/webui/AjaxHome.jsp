<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags" %>

<%
    request.setAttribute("decorator", "none");
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>

			<table summary="" cellpadding="0" cellspacing="0" border="0"
				height="100%" width="100%">
				<tr>
					<td width="70%"><!-- welcome begins -->
					<table summary="" cellpadding="0" cellspacing="0" border="0"
						height="100%" width="100%">
						<tr>
							<td class="welcomeTitle" height="20">WELCOME TO CABIO v4.1</td>
						</tr>
						<tr>
							<td class="welcomeContent" valign="top">The cancer
							Bioinformatics Infrastructure Objects (caBIO) model and
							architecture is a synthesis of software, vocabulary, and
							metadata models for cancer research. Each of the caBIO
							domain objects represents an entity found in biomedical
							research such as Gene, Chromosome, Nucleic Acid Sequence,
							SNP, Library, Clone, and Pathway. Given the dynamic nature
							of this information, the data in caBIO is updated on a
							monthly basis through a series of ETL (Extract, Transform,
							and Load) processes. <br>
							<br>
							References: <br>

							<ul>
								<li><a
									href="http://cabio.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO">
								caBIO Overview</a> - High-level overview of caBIO</li>
								<li><a href="https://gforge.nci.nih.gov/projects/cabiodb/">
								caBIO GForge site</a> - Contains news, information,
								documents, defects, feedback, and reports</li>
								<li><a
									href="http://ncicb.nci.nih.gov/download/downloadcabio.jsp">
								caBIO Download site</a> - Contains download packages and
								release notes</li>
								<li><a
									href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO/41/caBIO41_release_notes">caBIO
								4.1 Release Notes</a> - Latest release notes for caBIO</li>
								<li><a
									href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO/41/caBIO41_data_release_notes">caBIO 4.1
								Data Refresh Release Notes</a> - Release notes describing
								the current data content of caBIO</li>
								<li><a href="docs">caBIO 4.1 javadocs</a> - Java API
								documentation</li>
								<li><a href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO/41/caBIO41_tech_guide">caBIO 4.1 Tech Guide</a> - Technical
								Guide</li>
							</ul>
							</td>
						</tr>
					</table>
					<!-- welcome ends --></td>
					<td valign="top" width="30%"><!-- sidebar begins -->
					<table summary="" cellpadding="0" cellspacing="0" border="0"
						height="100%" width="100%">

						<!-- login/continue form begins -->
						<tr>
							<td valign="top">

							<table summary="" cellpadding="2" cellspacing="0" border="0"
								width="100%" class="sidebarSection">
								<tr>
									<td class="sidebarTitle" height="20">SELECT CRITERIA</td>
								</tr>
								<tr>
									<td class="sidebarContent" align="center"><s:form
										method="post" action="ShowDynamicTree.action"
										name="continueForm" theme="simple">
										<s:submit cssClass="actionButton" value="Continue"
											theme="simple" />
									</s:form></td>
								</tr>
							</table>

							</td>
						</tr>
						<!-- login ends -->

						<!-- what's new begins -->
						<tr>
							<td valign="top">
							<table summary="" cellpadding="0" cellspacing="0" border="0"
								width="100%" class="sidebarSection">
								<tr>
									<td class="sidebarTitle" height="20">WHAT'S NEW</td>
								</tr>
								<tr>
									<td class="sidebarContent">
									<ul>
									    <li>Genome Range Queries</li>
									    <li>Array Annotation API</li>
									    <li>Model updates to support caBIG™ standards</li>
									    <li>Cancer Gene Index data</li>
									    <li>UniSTS Marker Data</li>
										<!--  li><a href="search">FreestyleLM Search API</a></li -->
									</ul>
									</td>
								</tr>
							</table>
							</td>
						</tr>
						<!-- what's new ends -->

						<!-- spacer cell begins (keep for dynamic expanding) -->
						<tr>
							<td valign="top" height="100%">
							<table summary="" cellpadding="0" cellspacing="0" border="0"
								width="100%" height="100%" class="sidebarSection">
								<tr>
									<td class="sidebarContent" valign="top">&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<!-- spacer cell ends -->

					</table>
					<!-- sidebar ends --></td>
				</tr>
			</table>
<!--_____ main content ends _____-->
