.SUFFIXES: .java .class .rst .html ;

__CLASSPATH := \
	/usr/share/java/junit.jar \
	/usr/share/java/mongo-1.2.jar \
	.

CLASSPATH := \
	/usr/share/java/junit.jar \
	.

# Convert spaces to colons.
EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)
CLASSPATH:=$(subst $(SPACE),:,$(CLASSPATH))

JFLAGS=-cp $(CLASSPATH)

# BEGINSRCLIST
SOURCES = \
	net/willware/eurydice/core/AtomImpl.java \
	net/willware/eurydice/core/Atom.java \
	net/willware/eurydice/core/BondImpl.java \
	net/willware/eurydice/core/Bond.java \
	net/willware/eurydice/core/JigImpl.java \
	net/willware/eurydice/core/Jig.java \
	net/willware/eurydice/core/OrientationImpl.java \
	net/willware/eurydice/core/Orientation.java \
	net/willware/eurydice/core/Properties.java \
	net/willware/eurydice/core/StructureImpl.java \
	net/willware/eurydice/core/Structure.java \
	net/willware/eurydice/core/Substructure.java \
	net/willware/eurydice/core/UniqueId.java \
	net/willware/eurydice/db/MysqlInterface.java \
	net/willware/eurydice/db/StructureDatabase.java \
	net/willware/eurydice/elements/Carbon.java \
	net/willware/eurydice/elements/Hydrogen.java \
	net/willware/eurydice/elements/Nitrogen.java \
	net/willware/eurydice/elements/Oxygen.java \
	net/willware/eurydice/forcefields/ForceField.java \
	net/willware/eurydice/forcefields/mm2/AngleTerm.java \
	net/willware/eurydice/forcefields/mm2/LengthTerm.java \
	net/willware/eurydice/forcefields/mm2/LongRangeTerm.java \
	net/willware/eurydice/forcefields/mm2/TermImpl.java \
	net/willware/eurydice/forcefields/mm2/Term.java \
	net/willware/eurydice/forcefields/mm2/TorsionTerm.java \
	net/willware/eurydice/library/Aspirin.java \
	net/willware/eurydice/library/Buckyball.java \
	net/willware/eurydice/library/Diamond.java \
	net/willware/eurydice/library/DiamondRod.java \
	net/willware/eurydice/library/Propane.java \
	net/willware/eurydice/library/TwoRings.java \
	net/willware/eurydice/library/Water.java \
	net/willware/eurydice/math/Matrix.java \
	net/willware/eurydice/math/PhysicalUnit.java \
	net/willware/eurydice/math/Quantity.java \
	net/willware/eurydice/math/Quaternion.java \
	net/willware/eurydice/math/Region.java \
	net/willware/eurydice/math/Vector.java \
	net/willware/eurydice/nanocad/AtomEntry.java \
	net/willware/eurydice/nanocad/AWTApplet.java \
	net/willware/eurydice/nanocad/AWTEngine.java \
	net/willware/eurydice/nanocad/BondEntry.java \
	net/willware/eurydice/nanocad/DrawingEngineImpl.java \
	net/willware/eurydice/nanocad/ForceEntry.java \
	net/willware/eurydice/nanocad/NanocadNativeFormat.java \
	net/willware/eurydice/nanocad/NanocadStyleMM2.java \
	net/willware/eurydice/nanocad/NanocadStyleStructure.java \
	net/willware/eurydice/serialization/Filetype.java \
	net/willware/eurydice/serialization/PdbFile.java \
	net/willware/eurydice/serialization/XyzFile.java \
	net/willware/eurydice/tests/DatabaseTests.java \
	net/willware/eurydice/tests/LinearAlgebraTests.java \
	net/willware/eurydice/view/Color.java \
	net/willware/eurydice/view/DrawingEngine.java \
	net/willware/eurydice/view/Entry.java \
	net/willware/eurydice/view/PerspectiveImpl.java \
	net/willware/eurydice/view/Perspective.java \
	net/willware/eurydice/view/RasmolDrawing.java \
	net/willware/eurydice/view/ScreenSpaceImpl.java \
	net/willware/eurydice/view/ScreenSpace.java \

# ENDSRCLIST

CLASSES = $(SOURCES:.java=.class)

JARFILE = eurydice.jar
ZIPFILE = eurydice.zip

.java.class:
	javac $(JFLAGS) $(@:.class=.java)

.rst.html:
	rst2html $< /tmp/rst.html
	head -$$(egrep -n '^</body>$$' /tmp/rst.html | sed 's/:.*//') /tmp/rst.html | \
		tail --lines=+$$(egrep -n '^<body>$$' /tmp/rst.html | sed 's/:.*//') | \
		grep -v "<div class" | grep -v "</div>" | \
		sed "s#<h1 class=\"title\">#<h1>#" > $@

jar: $(JARFILE)

# I keep needing to do this...
update-java-list:
	head -$$(grep -n BEGINSRCLIST Makefile | head -1 | sed 's/:.*//') Makefile
	echo SOURCES = \\
	make --quiet ls-java | sed 's/^/\t/' | sed 's/$$/ \\/'
	echo
	tail --lines=+$$(grep -n ENDSRCLIST Makefile | head -1 | sed 's/:.*//') Makefile

ls-java:
	git ls-files | egrep '\.java$$' | sort

zip: $(ZIPFILE)

$(ZIPFILE): $(CLASSES)
	zip $(ZIPFILE) $(CLASSES)

$(JARFILE): $(CLASSES)
	jar cvf $(JARFILE) $(SOURCES) $(CLASSES)

classes:
	make $(CLASSES)

indent:
	astyle -A2 $$(find * -name "*.java")

tests: $(JARFILE)
	java $(JFLAGS) net.willware.eurydice.tests.DatabaseTests
	java $(JFLAGS) net.willware.eurydice.tests.LinearAlgebraTests

run-applet: $(JARFILE)
	java $(JFLAGS) net.willware.eurydice.view.AWTApplet

PACKAGE_DESCRIPTIONS = net/willware/eurydice/core/package.html \
	net/willware/eurydice/db/package.html \
	net/willware/eurydice/view/package.html \
	net/willware/eurydice/elements/package.html \
	net/willware/eurydice/forcefields/package.html \
	net/willware/eurydice/forcefields/mm2/package.html \
	net/willware/eurydice/library/package.html \
	net/willware/eurydice/math/package.html \
	net/willware/eurydice/serialization/package.html \
	net/willware/eurydice/tests/package.html

show-doc: html/index.html
	x-www-browser html/index.html &

doc: html/index.html

html/index.html: overview.html $(PACKAGE_DESCRIPTIONS)
	javadoc -overview overview.html -d html $$(find . -name '*.java')

doc-tarball: overview.html $(PACKAGE_DESCRIPTIONS)
	rm -rf nc2-javadoc
	javadoc -overview overview.html -d nc2-javadoc $$(find . -name '*.java')
	tar cfz ~/nc2-javadoc.tgz nc2-javadoc
	rm -rf nc2-javadoc

clean:
	rm -f *~ $$(find . -name "*.class") $(JARFILE) $(ZIPFILE)
	rm -f *~ $$(find . -name "package.html")
	rm -f *~ $$(find . -name "*.java.orig")
	rm -rf html overview.html $(PACKAGE_DESCRIPTIONS)

rsthtml = \
	rst2html $(2) /tmp/rst.html; \
	head -$$(egrep -n '^</body>$$' < /tmp/rst.html | sed 's/:.*//') < /tmp/rst.html | \
		tail --lines=+$$(egrep -n '^<body>$$' < /tmp/rst.html | sed 's/:.*//') | \
		grep -v '<div class' | grep -v '</div>' | \
		sed 's\#<h1 class="title">\#<h1>\#' > $(1)

net/willware/eurydice/core/package.html: net/willware/eurydice/core/README.rst
	$(call rsthtml, net/willware/eurydice/core/package.html, net/willware/eurydice/core/README.rst)
net/willware/eurydice/db/package.html: net/willware/eurydice/db/README.rst
	$(call rsthtml, net/willware/eurydice/db/package.html, net/willware/eurydice/db/README.rst)
net/willware/eurydice/view/package.html: net/willware/eurydice/view/README.rst
	$(call rsthtml, net/willware/eurydice/view/package.html, net/willware/eurydice/view/README.rst)
net/willware/eurydice/elements/package.html: net/willware/eurydice/elements/README.rst
	$(call rsthtml, net/willware/eurydice/elements/package.html, net/willware/eurydice/elements/README.rst)
net/willware/eurydice/forcefields/package.html: net/willware/eurydice/forcefields/README.rst
	$(call rsthtml, net/willware/eurydice/forcefields/package.html, net/willware/eurydice/forcefields/README.rst)
net/willware/eurydice/forcefields/mm2/package.html: net/willware/eurydice/forcefields/mm2/README.rst
	$(call rsthtml, net/willware/eurydice/forcefields/mm2/package.html, net/willware/eurydice/forcefields/mm2/README.rst)
net/willware/eurydice/library/package.html: net/willware/eurydice/library/README.rst
	$(call rsthtml, net/willware/eurydice/library/package.html, net/willware/eurydice/library/README.rst)
net/willware/eurydice/math/package.html: net/willware/eurydice/math/README.rst
	$(call rsthtml, net/willware/eurydice/math/package.html, net/willware/eurydice/math/README.rst)
net/willware/eurydice/serialization/package.html: net/willware/eurydice/serialization/README.rst
	$(call rsthtml, net/willware/eurydice/serialization/package.html, net/willware/eurydice/serialization/README.rst)
net/willware/eurydice/tests/package.html: net/willware/eurydice/tests/README.rst
	$(call rsthtml, net/willware/eurydice/tests/package.html, net/willware/eurydice/tests/README.rst)

overview.html: README.rst
	$(call rsthtml, overview.html, README.rst)
