import 'package:fluent_ui/fluent_ui.dart';

import 'bodyTexView.dart';

class TermView extends StatelessWidget {
  const TermView({super.key});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('利用規約'),
      ),
      children: [
        SingleChildScrollView(
          child: Container(

            margin : const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            padding: const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            child:  const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                BodyTextView(txtText: "株式会社ウイネット（以下「当社」といいます）と電子書籍配信システムManaMo（以下「本サービス」といいます）から電子書籍を取得した者（以下「利用者」といいます）は本サービスから配信される電子書籍（アプリ版も含む）の利用について以下の通り、利用規約（以下「本規約」といいます）に合意します。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "第１条（利用規約の適用）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は本規約に基づき「ManaMo®」及び付随する一連のサービスを本件書店及び学校、利用者に提供します。本規約は、当社と本件書店及び学校、利用者との間の本サービスの利用に関わる一切の関係に適用されます。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "第２条（定義）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．本規約における用語を以下の通り定義します。", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyTextView(txtText: "（１）「利用者」とは、本サービス上で出版社又は電子書店から書籍等のデータ(以下「電子書籍」といいます）を閲覧する権利を、出版社、電子書店及び当社が認める正当な方法により取得した者をいいます。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（２）「出版社」とは、書籍の電子データ（以下「本件コンテンツ」といいます）を保持し、利用者に対して本件コンテンツを利用する権利（本件コンテンツのダウンロードによる利用を含む）を非独占的に許諾することができる者をいいます。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（３）「学校」とは、利用者が所属する教育機関及び関連する企業、団体をいいます。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（４）「本件書店」とは、本サービス上で学校又は利用者に対して出版社から許諾を得た本件コンテンツを販売等する事業者をいいます。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（５）「利用者設備」とは、本サービスを利用するため利用者が使用するコンピューター、スマートフォン（タブレット含む）及びソフトウェアを意味します。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（６）「利用者情報」とは当社のプライバシーポリシーに定める一定の情報を意味します。", type: TextAlign.justify, scale: 1.0,),
                    ],
                  ),

                ),
                BodyTextView(txtText: "２．本サービスが理由の如何を問わず、名称または内容が変更された場合でも当該変更後のサービスに本規約が適用されるものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第３条（使用権の許諾）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "本規約に合意することを前提に、当社は本件書店及び学校、利用者に対して地域を限定することなく本サービスの非独占的かつ譲渡不可能な使用権を許諾します。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第４条（サービス概要）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．本サービスは電子書籍ビューアとして提供されるブラウザ及びアプリサービス、本件コンテンツを出版社が配信した配信データ（以下「本件配信データ」）の管理機能として提供されるクラウドサービスであり、インターネット環境下（アプリに格納した本件配信データはインターネット環境に依存せず）で利用可能です。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．動作可能なＯＳ、ブラウザ等の条件は製品概要の定めによるものとし、本件書店及び学校、利用者はその動作条件に適した利用者設備で利用するものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．利用者は本サービスにより出版社又は電子書店から提供される本件配信データを閲覧し利用する非独占的な利用権を取得するものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "４．電子書籍ビューア機能は、１名の個人に対して１台又は複数台の利用設備で動作させることができますが、必ずしも複数台の利用設備で利用できることを保証するものではありません。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "５．アプリ利用において機種変更時は新たにアプリのダウンロード及び設定を行っていただく必要があります。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "６．当社は予告なく本サービスの機能変更・追加等を行えるものとし、それら全てに本規約が適用されるものとします。本サービスの重要な変更について、随時利用者に通知します。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第５条（利用の開始）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．学校教職員又は教職員から指示を受けた本件書店が利用者情報を当社の定める方法で当社に提供することで本サービスの利用を開始するものとします。なお、本サービスで利用者情報を登録等し当社に提供した時点で利用者は当社に利用者情報を提供すること及び本規約を遵守することに同意したものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．当社は利用者が以下の各号のいずれかの事由に該当する場合は、利用を拒否することがありまたその理由について一切開示義務を負いません。", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyTextView(txtText: "（１）当社に提供した利用者情報の全てまたは一部につき故意に虚偽、誤記又は記載を漏らした場合", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（２）反社会的勢力（暴力団、暴力団員、右翼団体、反社会的勢力、その他これに準ずる者を意味します。）である、又は資金提供その他を通じて、反社会的勢力等の維持、運営もしくは経営に協力もしくは関与する等反社会的勢力等との何らかの交流もしくは関与を行っていると当社が判断した場合", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（３）過去に当社との契約に違反した者、又はその関係者であると当社が判断した場合", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（４）その他当社が利用を適切でないと判断した場合", type: TextAlign.justify, scale: 1.0,),
                    ],
                  ),

                ),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第６条（知的財産権）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．本サービスについての知的財産権（著作権、特許権、実用新案権、意匠権、その他の知的財産権それらの権利の購入、またはそれらの権利につき登録等を出願する権利を含みます。）は当社に帰属します。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．本件コンテンツの知的財産権（著作権、特許権、実用新案権、意匠権、その他の知的財産権それらの権利の購入、またはそれらの権利につき登録等を出願する権利を含みます。）は出版社又は本件書店に帰属します。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．学校及び利用者は前2 項を理解し、各権利者に帰属する権利を尊重するとともに、当該権利を侵害しないことを誓約するものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第７条（利用者情報の変更）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "利用者は利用者情報に変更があった場合、当該変更事項を当社の定める方法で当社に提供することに同意するものとします。なお、提供に係る作業を学校又は本件書店が代行することができるものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第８条（利用者情報の管理）", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "利用者は自己の責任において本サービスの利用に関する利用者情報を適切に管理及び保管するものとします。第三者への貸与、譲渡、名義変更、売買等をしてはならないものとします。また、管理不十分、使用上の過誤で生じた損害に関する責任は利用者が負うものとし、当社は一切の責任を負いません。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第９条（有効期間）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "本サービスは学校の決定により利用を終了するか、利用者が自らの意思で利用を終了するまでは有効に利用できます。ただし、当社が合理的な判断のもと本サービスを改変又は終了することで利用者の利用を終了させる場合があります。その場合は、終了日予定日の３か月前までに利用者に通知することで本サービスの改変又は終了ができるものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第10条（本件コンテンツ利用料）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "利用者は学校の指示により本件書店又は出版社が定めた正当な購入手続き等により本件コンテンツの購入が行えるものとします。購入費用の支払い等は、学校又は本件書店が定める方法に従って支払いを行うこととします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第11条（継続利用と中断、停止）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．当社は、サービスレベルオブジェクティブの定めによりサービスレベルが継続的に提供されます。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．当社は、前項の定めにかかわらず本件書店又は学校、利用者が第１3 条（当社からの利用契約の解約）に該当する又は利用者が学校又は本件書店、出版社との契約等に違反した場合には、利用者への事前の通知若しくは催告を要することなく本サービスの全部又は一部の提供を停止することができるものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．当社は前項に定める事由により本サービスが提供されず、本件書店又は学校、利用者並びにその他第三者が損害を被った場合であっても一切責任を負わないものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第12条（禁止事項）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．本件書店及び学校、利用者は本サービスの利用に関して、以下の行為を行わないものとします。", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyTextView(txtText: "（１）当社若しくは第三者の著作権、商標権などの知的財産権その他の権利を侵害する行為、又は侵害するおそれのある行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（２）本サービスに係る情報を改ざん、消去する行為、利用外の目的で使用、改ざん、解析する行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（３）出版社又は本件書店の著作権、商標権などの知的財産権その他の権利を侵害する行為、又は侵害するおそれのある行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（４）出版社又は本件書店から配信された本件配信データを許諾なく複製又は改ざん、解析する行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（５）出版社又は本件書店から配信された本件配信データを画面表示し、許諾なく表示画面を撮影したデータを保存し二次的使用又は第三者に提供する行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（６）本規約に違反して、第三者に本サービスを利用させる行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（７）第三者になりすまして本サービスを利用する行為", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（８）法令若しくは公序良俗に違反し、又は当社若しくは出版社及び本件書店、学校、第三者に不利益を与える行為", type: TextAlign.justify, scale: 1.0,),
                    ],
                  ),

                ),
                BodyTextView(txtText: "２．前項第４号の行為には、本サービスが保有する電子書籍ビューア機能を使用して自己の学習等のために本件配信データに書き込み機能又は付箋機能利用等を使用することは含まれせん。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．本件書店及び学校、利用者は第1 項各号のいずれかに該当する行為がなされた、又は該当する行為がなされるおそれがあると判断した場合は、直ちに当社に通知するものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "４．当社は本サービスの利用に関して、本件書店又は学校、利用者等の行為又は提供した情報が第１項各号のいずれかの行為にあたる、若しくは関連すると知った場合、事前にこれら関係者に通知することなく、本サービスの全部又は一部の提供を一時停止し、又は第１項各号に該当する行為に関連する情報を削除することができるものとします。ただし、当社は、本件書店及び学校、利用者等の行為又は利用者等が提供または伝送する（利用者の利用とみなされる場合も含みます。）情報（データ、コンテンツを含みます。）を監視する義務を負うものではありません。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第13条（当社からのサービス利用契約の解約）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は、利用者が本規約のいずれかの条項に違反した場合、または履行することが困難となる事由が生じた場合、利用者への事前の通知若しくは催告を要することなく利用契約の全部若しくは一部を解約することができるものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第14条（秘密情報の取り扱い）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．当社及び本件書店並びに学校、利用者は、本サービス遂行のため相手方より提供を受けた技術・営業・その他業務の情報のうち、相手方が特に秘密である旨あらかじめ書面で指定した情報で、提供の際に秘密情報の範囲を特定し、秘密情報である旨の表示を明記した情報（以下「秘密情報」といいます）を第三者に開示又は漏洩しないものとします。ただし、相手方からあらかじめ書面による承諾を受けた場合及び次の各号のいずれかに該当する情報についてはこの限りではありません。", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyTextView(txtText: "（１）秘密保持義務を負うことなく既に保有している、また第三者から正当に入手した情報", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（２）相手方から提供を受けた情報によらず、独自に開発した情報", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（３）利用規約等に違反することなく、かつ、受領の前後を問わず公知となった情報", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "（４）本条に従った指定、範囲の特定や秘密情報である旨の表示がなされず提供された情報", type: TextAlign.justify, scale: 1.0,),
                    ],
                  ),

                ),
                BodyTextView(txtText: "２．前項の定めにかかわらず、当社と利用者で別途定める秘密情報については、前項に定める秘密である旨の指定、範囲の特定、表示がなされたものとみなします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．前各項の定めにかかわらず、利用者及び当社は、秘密情報のうち法令の定めに基づき又は権限ある官公署からの要求により開示すべき情報を、当該法令の定めに基づく開示先又は当該官公署に対し開示することができるものとします。この場合、利用者及び当社は、関連法令に反しない限り、当該開示前に開示する旨を相手方に通知するものとし、開示前に通知を行うことができない場合は開示後すみやかにこれを行うものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "４．秘密情報の提供を受けた当事者は、当該秘密情報の管理に必要な措置を講ずるものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "５．本条の規定は、本サービス終了後、３年間有効に存続するものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第15条（個人情報の取り扱い）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．当社による本件書店従業員及び学校教職員並びに利用者の情報の取扱いについては、当社プライバシーポリシーの定めによるものとし、これら関係者は当社が個人情報及び利用情報を取り扱うことについて同意するものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．当社は、本件書店及び学校、利用者が当社に提供した情報、データ等を、個人を特定できない形での統計的な情報として、当社の裁量で利用及び公開することができるものとし、本件書店及び学校、利用者はこれに異議を唱えないものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．当社は、本件書店及び学校、利用者のニーズにあったサービスを提供するため、端末情報、アプリの利用履歴及びログデータ等、本システムを利用している者の個人情報以外の情報（電子書籍の利用状況や学習履歴を含む）を収集することがあります。収集した情報は当社の裁量で個人を特定しない方法で統計的な解析や二次的サービスの提供、出版社や電子書店への情報提供等に利用することができます。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "４．本条の規定は、本サービス終了後も有効に存続するものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第16条（本規約の変更）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は、本規約を変更できるものとします。当社は、本規約を変更した場合には本件書店及び学校、利用者に当該変更内容を通知するものとし、当該変更内容の通知後、本件書店及び学校、利用者が本サービスを利用した時点をもって利用者は本規約の変更に同意したものとみなします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第17条（権利義務譲渡の禁止）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "本件書店及び学校、利用者はあらかじめ当社の書面による承諾がない限り、サービス利用上の地位、利用規約に基づく権利又は義務の全部又は一部を他に譲渡してはならないものとします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "第18条（合意管轄及び準拠法）", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "１．本件書店又は学校並びに利用者と当社の間で訴訟の必要が生じた場合、被告の本店所在地の管轄裁判所とします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "２．出版社又は本件書店、学校と利用者の間で訴訟の必要が生じた場合、並びにこれら関係者の間で紛争が生じた場合、当社は一切関知せず関係者間での解決を図るものとします。また、これにより生じた違約金や損害賠償の支払い義務は当社にないものとします。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "３．本契約等の成立、効力、履行及び解釈に関する準拠法は、日本法とします。", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 8,),
                BodyStrongTextView(txtText: "以上", type: TextAlign.justify, scale: 1.0,),
                SizedBox(height: 20,)
              ],
            ),
          ),
        )
      ],
    );
  }
}

